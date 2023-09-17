'''
READ ME

To run this code properly, all images and font from the uploaded zipped folder 'Chess' should
be present in the working directory. These are the fonts and images referenced in the program


This code will run an interface for playing 2 player local chess.
There are three game modes corresponding to differnt time limits
Easy: no time limit             Blitz: 5 min time limit        Bullet: 1 min time limit
The main menu consists of the 3 mode buttons and 2 player buttons to view player statistics.
When a game mode button is clicked the game will ask which player will be white and the game begins.
To move a piece click it and all viable moves will appear. Click the highlighted squares to move to that piece.
The game could end by resigning, accepting an offered draw, time limit, or by regular checkmate.
After a game is over you can choose to go to the first main menu or restart the game.
All game statistcs are stored for the current session and can be viewed in the main menu.
'''




import numpy as np
import pygame as pg


class Game:
    def __init__(self,game_mode,white_player,black_player):

        self.image = pg.image.load("board.png")
        self.rect = self.image.get_rect(center=(center_x,center_y))

        self.players=[white_player, black_player]

        self.game_mode=game_mode
        if self.game_mode==0:
            self.time=[np.Inf,np.Inf]
        elif self.game_mode==1:
            self.time=[5*60,5*60]
        elif self.game_mode==2:
            self.time=[1*60,1*60]

        self.captured=np.array([])
        self.highlights=[]

        self.active_pieces=self.initialize_active_pieces()
        self.update_positions()

        self.cur_player=0
        self.selected_piece=None
        self.check=False
        self.end=False
        self.winner=None
        self.en_passant=False
        self.check_hl=None
        self.en_passant_pos=None
        self.pause=False
        self.promotion=False
        self.promo_piece=None
        self.promo_pawn=None

    def initialize_active_pieces(self):
        
        piece_array=['r','n','b','q','k','b','n','r','p','p','p','p','p','p','p','p']
        colors=[1,0]
        all_pieces=np.array([])
        positions=[(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(0,7),(1,0),(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),
                    (7,0),(7,1),(7,2),(7,3),(7,4),(7,5),(7,6),(7,7),(6,0),(6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7)]
        for n in range(0,32):
            all_pieces=np.append(all_pieces, Piece(piece_array[n%16], colors[n//16],positions[n])) 
        return all_pieces
    
    def update_positions(self):

        self.king_pos=[[],[]]
        self.all_positions=[[],[]]

        for active_piece in self.active_pieces:
            self.all_positions[active_piece.color].append(active_piece.pos)
            if active_piece.piece_type=='k':
                self.king_pos[active_piece.color].append(active_piece.pos)

    def load_board(self):
        screen.blit(self.image, self.rect)
        for highlight in self.highlights:
            screen.blit(highlight.image, highlight.rect)
        if self.check:
            screen.blit(self.check_hl.image,self.check_hl.rect)
        for piece in self.active_pieces:
            screen.blit(piece.image, piece.rect)
        for piece in self.captured:
            screen.blit(piece.image, piece.rect)
        if self.end:
            screen.blit(mate_bg, mate_bg_rect)
        
    def check_piece_click(self):
        if event.type == pg.MOUSEBUTTONDOWN  and event.button == 1:
            for piece in self.active_pieces:
                if piece.rect.collidepoint(pg.mouse.get_pos()) and self.cur_player == piece.color:
                    self.highlights=self.get_viable_moves(piece, False)
                    self.selected_piece=piece
                    break

    def check_highlight_click(self):
        if event.type == pg.MOUSEBUTTONDOWN and event.button == 1:
            for highlight in self.highlights:
                if highlight.rect.collidepoint(pg.mouse.get_pos()) and not(self.selected_piece==None):
                    self.move_piece(self.selected_piece,highlight)
                    self.selected_piece=None
                    self.cur_player=1-self.cur_player
                    break
                self.highlights=[]

    def move_piece(self,piece,highlight):
        self.check=False

        if piece.piece_type=='k' and abs(piece.pos[1]-highlight.pos[1])==2:
            if piece.pos[1]-highlight.pos[1]==2:
                self.move_piece(self.active_pieces[[x.pos for x in self.active_pieces].index((piece.pos[0],0))],Highlight((piece.pos[0],highlight.pos[1]+1)))
            if piece.pos[1]-highlight.pos[1]==-2:
                self.move_piece(self.active_pieces[[x.pos for x in self.active_pieces].index((piece.pos[0],7))],Highlight((piece.pos[0],highlight.pos[1]-1)))
        
        self.en_passant=False
        if piece.piece_type=='p' and abs(piece.pos[0]-highlight.pos[0])==2:
            self.en_passant=True
            if piece.pos[0]-highlight.pos[0]==2:
                self.en_passant_pos=(piece.pos[0]-1,piece.pos[1])
            else:
                self.en_passant_pos=(piece.pos[0]+1,piece.pos[1])
        en_passant_cap=piece.piece_type=='p' and abs(piece.pos[0]-highlight.pos[0])==1 and abs(piece.pos[1]-highlight.pos[1])==1
        
        piece.pos=highlight.pos
        piece.piece_x=((screen_width-board_width)/2)+30+piece.pos[1]*60
        piece.piece_y=((screen_height-board_width)/2)+30+piece.pos[0]*60
        piece.rect = piece.image.get_rect(center=(piece.piece_x,piece.piece_y))
        piece.has_moved=True

        if piece.piece_type=='p' and piece.pos in [(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),(0,7),(7,0),(7,1),(7,2),(7,3),(7,4),(7,5),(7,6),(7,7)]:
            self.promo_pawn=piece
            self.pause=True      
            self.promotion=True
            global all_buttons
            all_buttons=[rook_button, bishop_button, knight_button ,queen_button]    

        self.update_positions()
        self.capture_piece(piece,True,en_passant_cap)

        hlpos=self.get_all_color_highlights(piece.color,True)
        if self.king_pos[1-piece.color][0] in hlpos:
            self.check=True
            self.check_hl=Highlight((cur_game.king_pos[1-cur_game.cur_player][0][0],cur_game.king_pos[1-cur_game.cur_player][0][1]),True)
            op_hlpos=self.get_all_color_highlights(1-piece.color,False)
            if op_hlpos==[]:
                self.end=True
                self.pause=True
                self.winner=self.cur_player
                all_texts.append(win_text[self.winner])
                self.players[self.winner].color_wins[self.winner]+=1
                self.players[self.winner].mode_wins[self.game_mode]+=1
                self.players[1-self.winner].losses+=1
                all_buttons=[restart_button, main_menu_button]   
        
 
    def get_viable_moves(self,piece,overwrite):

        viable_moves=np.array([])
    
        all_positions=sum(self.all_positions,[])
        player_positions=self.all_positions[piece.color]
        attack_player=1-piece.color
        opp_positions=self.all_positions[1-piece.color]
        v=-1+2*piece.color
        
                    
        if piece.piece_type=='p':
            if piece.has_moved==False and not((piece.pos[0]+2*v,piece.pos[1]) in all_positions) and not((piece.pos[0]+1*v,piece.pos[1]) in all_positions):
                viable_moves=np.append(viable_moves,Highlight((piece.pos[0]+2*v,piece.pos[1])))   # double jump pawn
            if not((piece.pos[0]+1*v,piece.pos[1]) in all_positions):
                viable_moves=np.append(viable_moves,Highlight((piece.pos[0]+1*v,piece.pos[1])))   # single jump pawn
            if (piece.pos[0]+1*v,piece.pos[1]+1) in opp_positions or ((piece.pos[0]+1*v,piece.pos[1]+1)==self.en_passant_pos and self.en_passant==True):
                viable_moves=np.append(viable_moves,Highlight((piece.pos[0]+1*v,piece.pos[1]+1))) # eat right pawn
            if (piece.pos[0]+1*v,piece.pos[1]-1) in opp_positions or ((piece.pos[0]+1*v,piece.pos[1]-1)==self.en_passant_pos and self.en_passant==True):
                viable_moves=np.append(viable_moves,Highlight((piece.pos[0]+1*v,piece.pos[1]-1))) # eat left pawn

        if piece.piece_type=='b':
            steps=[[1,1],[1,-1],[-1,1],[-1,-1]]
            for n in range(4):
                pos_hl=(piece.pos)
                while True: 
                    pos_hl=(pos_hl[0]+steps[n][0],pos_hl[1]+steps[n][1])
                    if pos_hl[0]>7 or pos_hl[0]<0 or pos_hl[1]>7 or pos_hl[1]<0:
                        break
                    if pos_hl in player_positions:
                        break
                    if pos_hl in opp_positions:
                        viable_moves=np.append(viable_moves,Highlight(pos_hl))
                        break
                    viable_moves=np.append(viable_moves,Highlight(pos_hl))

        if piece.piece_type=='n':
            steps=[[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[1,-2],[-1,2],[-1,-2]]
            for n in range(8):
                pos_hl=(piece.pos[0]+steps[n][0],piece.pos[1]+steps[n][1])
                if not(pos_hl[0]>7 or pos_hl[0]<0 or pos_hl[1]>7 or pos_hl[1]<0) and not(pos_hl in player_positions):
                    viable_moves=np.append(viable_moves,Highlight(pos_hl))

        if piece.piece_type=='r':
            steps=[[1,0],[-1,0],[0,1],[0,-1]]
            for n in range(4):
                pos_hl=(piece.pos)
                while True: 
                    pos_hl=(pos_hl[0]+steps[n][0],pos_hl[1]+steps[n][1])
                    if pos_hl[0]>7 or pos_hl[0]<0 or pos_hl[1]>7 or pos_hl[1]<0:
                        break
                    if pos_hl in player_positions:
                        break
                    if pos_hl in opp_positions:
                        viable_moves=np.append(viable_moves,Highlight(pos_hl))
                        break
                    viable_moves=np.append(viable_moves,Highlight(pos_hl))
        
        if piece.piece_type=='q':
            steps=[[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
            for n in range(8):
                pos_hl=(piece.pos)
                while True: 
                    pos_hl=(pos_hl[0]+steps[n][0],pos_hl[1]+steps[n][1])
                    if pos_hl[0]>7 or pos_hl[0]<0 or pos_hl[1]>7 or pos_hl[1]<0:
                        break
                    if pos_hl in player_positions:
                        break
                    if pos_hl in opp_positions:
                        viable_moves=np.append(viable_moves,Highlight(pos_hl))
                        break
                    viable_moves=np.append(viable_moves,Highlight(pos_hl))

        if piece.piece_type=='k':
            steps=[[1,0],[1,-1],[1,1],[0,1],[0,-1],[-1,0],[-1,1],[-1,-1]]
            for n in range(8):
                pos_hl=(piece.pos[0]+steps[n][0],piece.pos[1]+steps[n][1])
                if not(pos_hl[0]>7 or pos_hl[0]<0 or pos_hl[1]>7 or pos_hl[1]<0) and not(pos_hl in player_positions):
                    viable_moves=np.append(viable_moves,Highlight(pos_hl))

            corner_row=7-piece.color*7
            corners=[(corner_row,7),(corner_row,0)]
            castle_pass=[[(corner_row,6),(corner_row,5),(corner_row,4)],[(corner_row,4),(corner_row,3),(corner_row,2)]]
            castle_middle=[[(corner_row,6),(corner_row,5)],[(corner_row,1),(corner_row,3),(corner_row,2)]]
            if self.cur_player==piece.color:
                for n in range(2):
                    piece_there=corners[n] in all_positions
                    checks=self.get_all_color_highlights(attack_player,True)
                    castle_not_check=not(any(x in checks for x in castle_pass[n]))
                    castle_empty=not(any(x in all_positions for x in castle_middle[n]))
                    if piece_there and self.cur_player==piece.color and castle_not_check and castle_empty and piece.has_moved==False and self.active_pieces[[x.pos for x in self.active_pieces].index(corners[n])].has_moved==False:
                        viable_moves=np.append(viable_moves,Highlight((piece.pos[0],piece.pos[1]+2-n*4)))

        if overwrite==False:
            piece_real_pos=piece.pos

            for move in viable_moves:

                self.active_pieces[np.where(self.active_pieces == piece)[0][0]].pos=move.pos

                diagonal=abs(piece.pos[0]-move.pos[0])==1 and abs(piece.pos[1]-move.pos[1])==1
                en_passant_cap=piece.piece_type=='p' and diagonal
        
                has_eaten=self.capture_piece(piece,False,en_passant_cap)
                self.update_positions()

                attack_player_highlights=self.get_all_color_highlights(attack_player,True)

                if self.king_pos[piece.color][0] in attack_player_highlights:
                    viable_moves=np.delete(viable_moves,np.where(viable_moves == move)[0][0])
                        
                if has_eaten:
                    self.active_pieces=np.append(self.active_pieces,self.captured[-1])
                    self.captured=np.delete(self.captured,-1)

            self.active_pieces[np.where(self.active_pieces == piece)[0][0]].pos=piece_real_pos
            self.update_positions()

        return viable_moves

    def capture_piece(self, piece, true_capture, en_passant_cap):
        captured=False
        pos_check=piece.pos
        while(1):
            for other_piece in self.active_pieces:
                if other_piece.pos==pos_check and not(other_piece==piece):
                    cap_len=[len([x for x in self.captured if x.color==0]),len([x for x in self.captured if x.color==1])]
                    self.captured=np.append(self.captured,other_piece)
                    self.active_pieces=np.delete(self.active_pieces,np.where(self.active_pieces == other_piece)[0][0])
                    captured=True
                    if true_capture:
                        other_piece.pos=(cap_len[other_piece.color]%5+1,10-13*other_piece.color+(-1+2*other_piece.color)*(cap_len[other_piece.color]//5))
                        other_piece.piece_x=((screen_width-board_width)/2)+30+other_piece.pos[1]*60
                        other_piece.piece_y=((screen_height-board_width)/2)+30+other_piece.pos[0]*60
                        other_piece.rect = other_piece.image.get_rect(center=(other_piece.piece_x,other_piece.piece_y))
                    return captured
            if en_passant_cap:
                pos_check=(piece.pos[0]+1-2*self.cur_player,piece.pos[1])
            else:
                return captured


    def get_all_color_highlights(self,color,immediate):
        color_highlights=[]
        for color_piece in self.active_pieces:
            if color_piece.color==color:
                color_highlights.append([x.pos for x in self.get_viable_moves(color_piece,immediate)])
        color_highlights=sum(color_highlights, [])
        return color_highlights


class Piece:
    def __init__(self,piece_type,color,pos):
        self.piece_type = piece_type
        self.color = color
        self.pos=pos
        self.has_moved=False
        self.image = pg.image.load(piece_type+str(color)+".png")
        self.piece_x=((screen_width-board_width)/2)+30+self.pos[1]*60
        self.piece_y=((screen_height-board_width)/2)+30+self.pos[0]*60
        self.rect = self.image.get_rect(center=(self.piece_x,self.piece_y))
    
class Highlight:
    def __init__(self,pos,green=False):
        self.pos=pos
        if green:
            self.image = pg.image.load("greenglow.png")
        else:
            self.image = pg.image.load("blueglow.png")
        hl_x=((screen_width-board_width)/2)+30+self.pos[1]*60
        hl_y=((screen_height-board_width)/2)+30+self.pos[0]*60
        self.rect = self.image.get_rect(center=(hl_x,hl_y))

class Player:
    def __init__(self,number):
        self.number=number
        self.color_wins=[0,0]
        self.draws=0
        self.losses=0
        self.mode_wins=[0, 0, 0]
    def get_stats(self):
        color_wins_stat=f'Wins as White: {self.color_wins[0]}     Wins as Black: {self.color_wins[1]}'
        mode_wins_stat=f'Wins in Easy: {self.mode_wins[0]}     Wins in Blitz: {self.mode_wins[1]}      Wins in Bullet: {self.mode_wins[2]}'
        losses_stat=f'Total Losses: {self.losses}'
        draws_stat=f'Total Draws: {self.draws}'

        color_text=Text((center_x,50), color_wins_stat, 'Hunger Games', 20, 'Black')
        mode_text=Text((center_x,150), mode_wins_stat, 'Hunger Games', 20, 'Black')
        losses_text=Text((center_x,250), losses_stat, 'Hunger Games', 20, 'Black')
        draws_text=Text((center_x,300), draws_stat, 'Hunger Games', 20, 'Black')

        return [color_text, mode_text, losses_text, draws_text]

class Text:
    def __init__(self, pos, text, font, font_size, color):
        if font==None:
            self.font=pg.font.SysFont(None, font_size)
        else:
            self.font = pg.font.Font(font+".ttf",font_size)
        self.text = self.font.render(text,True,color)
        self.pos=pos
        self.color=color
        self.text_rect = self.text.get_rect(center=pos)
    def render(self,screen):
        screen.blit(self.text, self.text_rect)

class Button:
    def __init__(self,pos,text,font,font_size,color,command):
        self.image = pg.image.load("unselected_button_green.png")
        self.rect = self.image.get_rect(center=pos)
        self.pos=pos
        self.text=text
        self.button_text=Text(pos,text,font,font_size,color)
        self.command = command
    def render(self, screen):
        screen.blit(self.image, self.rect)
        screen.blit(self.button_text.text, self.button_text.text_rect)        
    def change_style(self):
        self.image = pg.image.load("selected_button_green.png")
    def revert_style(self):
        self.image = pg.image.load("unselected_button_green.png")

def button_func(self):
    global cur_game, cur_game_active,all_buttons,pause,selected_mode, all_texts
    if self.text=='Easy':
        selected_mode=0
        all_buttons=[select_white_button, select_black_button]
        all_texts=[choose_white_text, game_will_start_text]
        white_timer.text= white_timer.font.render('',True,white_timer.color)
        black_timer.text=black_timer.font.render('',True,black_timer.color)
    elif self.text=='Blitz':
        selected_mode=1
        all_buttons=[select_white_button, select_black_button]
        all_texts=[choose_white_text, game_will_start_text]
        white_timer.text= white_timer.font.render('5:00',True,white_timer.color)
        black_timer.text=black_timer.font.render('5:00',True,black_timer.color)
    elif self.text=='Bullet':
        selected_mode=2
        all_buttons=[select_white_button, select_black_button]
        all_texts=[choose_white_text, game_will_start_text]
        white_timer.text= white_timer.font.render('1:00',True,white_timer.color)
        black_timer.text=black_timer.font.render('1:00',True,black_timer.color)
    elif self.text=='Restart':
        cur_game=Game(cur_game.game_mode, cur_game.players[0], cur_game.players[1])
        all_buttons=[resign_button_white,draw_button_white,resign_button_black,draw_button_black]
        cur_game.pause=False
        all_texts=[white_timer, black_timer]
    elif self.text=='Main Menu':  
        cur_game_active=0
        all_buttons=[easy_button, blitz_button,bullet_button,p1_stat_button,p2_stat_button]
        cur_game.pause=False
        all_texts=[mm_title]
    elif self.text=='White Resign': 
        cur_game.end=1
        cur_game.pause=True
        cur_game.winner=1
        all_texts.append(win_text[cur_game.winner])
        all_buttons=[restart_button, main_menu_button]
        cur_game.players[1].color_wins[1]+=1
        cur_game.players[1].mode_wins[cur_game.game_mode]+=1
        cur_game.players[0].losses+=1
    elif self.text=='Black Resign': 
        cur_game.end=1
        cur_game.pause=True
        cur_game.winner=0
        all_texts.append(win_text[cur_game.winner])
        all_buttons=[restart_button, main_menu_button]
        cur_game.players[0].color_wins[0]+=1
        cur_game.players[0].mode_wins[cur_game.game_mode]+=1
        cur_game.players[1].losses+=1
    elif self.text=='White Offer Draw': 
        cur_game.pause=True
        all_buttons.append(black_side_accept)
        all_buttons.append(black_side_decline)
    elif self.text=='Black Offer Draw': 
        cur_game.pause=True
        all_buttons.append(white_side_accept)
        all_buttons.append(white_side_decline)
    elif self.text=='Accept':
        cur_game.winner=-1
        cur_game.pause=True
        if cur_game.end==0:
            cur_game.players[0].draws+=1
            cur_game.players[1].draws+=1
        cur_game.end=1
        all_texts.append(draw_text)
        all_buttons=[restart_button, main_menu_button]
    elif self.text=='Decline':
        all_buttons=[resign_button_white,draw_button_white,resign_button_black,draw_button_black]
        cur_game.pause=False
    elif self.text=='P1':
        cur_game=Game(selected_mode,p1,p2)
        cur_game_active=1
        all_buttons=[resign_button_white,draw_button_white,resign_button_black,draw_button_black]
        all_texts=[white_timer, black_timer]
    elif self.text=='P2':
        cur_game=Game(selected_mode,p2,p1)
        cur_game_active=1
        all_buttons=[resign_button_white,draw_button_white,resign_button_black,draw_button_black]
        all_texts=[white_timer, black_timer]
    elif self.text=='Player 1':
        all_buttons=[back_button]
        all_texts=p1.get_stats()
    elif self.text=='Player 2':
        all_buttons=[back_button]
        all_texts=p2.get_stats()
    elif self.text=='Back':
        all_buttons=[easy_button, blitz_button,bullet_button,p1_stat_button,p2_stat_button]
        all_texts=[mm_title]
    elif self.text=='Bishop':
        cur_game.promo_piece='b'
        all_buttons=[resign_button_white,draw_button_white,resign_button_black,draw_button_black]
        cur_game.active_pieces[np.where(cur_game.active_pieces == cur_game.promo_pawn)[0][0]]=Piece(cur_game.promo_piece,cur_game.promo_pawn.color,cur_game.promo_pawn.pos)
        cur_game.promotion=False
        cur_game.pause=False
    elif self.text=='Rook':
        cur_game.promo_piece='r'
        all_buttons=[resign_button_white,draw_button_white,resign_button_black,draw_button_black]
        cur_game.active_pieces[np.where(cur_game.active_pieces == cur_game.promo_pawn)[0][0]]=Piece(cur_game.promo_piece,cur_game.promo_pawn.color,cur_game.promo_pawn.pos)
        cur_game.promotion=False
        cur_game.pause=False
    elif self.text=='Knight':
        cur_game.promo_piece='n'
        all_buttons=[resign_button_white,draw_button_white,resign_button_black,draw_button_black]
        cur_game.active_pieces[np.where(cur_game.active_pieces == cur_game.promo_pawn)[0][0]]=Piece(cur_game.promo_piece,cur_game.promo_pawn.color,cur_game.promo_pawn.pos)
        cur_game.promotion=False
        cur_game.pause=False
    elif self.text=='Queen':
        cur_game.promo_piece='q'
        all_buttons=[resign_button_white,draw_button_white,resign_button_black,draw_button_black]
        cur_game.active_pieces[np.where(cur_game.active_pieces == cur_game.promo_pawn)[0][0]]=Piece(cur_game.promo_piece,cur_game.promo_pawn.color,cur_game.promo_pawn.pos)
        cur_game.promotion=False
        cur_game.pause=False

def check_buttons():
    for button in all_buttons:
        button.render(screen)
        if button.rect.collidepoint(pg.mouse.get_pos()):
            button.change_style()
            if event.type == pg.MOUSEBUTTONDOWN and event.button == 1:
                button.command(button)
        else:
            button.revert_style()

def check_texts():
    for text in all_texts:
        text.render(screen)

def check_timers():
    global all_buttons
    if cur_game.game_mode>0:
        cur_game.time[cur_game.cur_player]-= 1
        min_white=cur_game.time[0]//60
        sec_white=cur_game.time[0]%60
        min_black=cur_game.time[1]//60
        sec_black=cur_game.time[1]%60
        white_timer.text= white_timer.font.render(f'{min_white}:{"{:02d}".format(sec_white)}',True,white_timer.color)
        black_timer.text=black_timer.font.render(f'{min_black}:{"{:02d}".format(sec_black)}',True,black_timer.color)
    if cur_game.time[0]<=0:
        cur_game.winner=1
        all_texts.append(win_text[cur_game.winner])
        all_buttons=[restart_button, main_menu_button]
        cur_game.end=True
        cur_game.pause=True
        cur_game.players[cur_game.winner].color_wins[cur_game.winner]+=1
        cur_game.players[cur_game.winner].mode_wins[cur_game.game_mode]+=1
        cur_game.players[1-cur_game.winner].losses+=1
    if cur_game.time[1]<=0:
        cur_game.winner=0
        cur_game.players[cur_game.winner].color_wins[cur_game.winner]+=1
        cur_game.players[cur_game.winner].mode_wins[cur_game.game_mode]+=1
        cur_game.players[1-cur_game.winner].losses+=1
        all_texts.append(win_text[cur_game.winner])
        cur_game.end=True
        cur_game.pause=True
        all_buttons=[restart_button, main_menu_button]

        
# Initialization
pg.init()
pg.display.set_caption('Chess App')
clock = pg.time.Clock()

# Screen Dimensions
screen_width=850
screen_height=480
board_width=480
screen = pg.display.set_mode((screen_width,screen_height))
center_x=screen_width/2
center_y=screen_height/2

# Timer
timer_event = pg.USEREVENT+1
pg.time.set_timer(timer_event, 1000)

# Images
mm_bg = pg.image.load("bg1.png")
mm_bg_rect=mm_bg.get_rect(center=(center_x,center_y))

mate_bg = pg.image.load("greytrans.png")
mate_bg_rect=mate_bg.get_rect(center=(center_x,100))

#mate_bg_rect = mate_bg.get_rect(center=(center_x,100))
# Texts
mm_title = Text((center_x,40), 'CHESS', 'Hunger Games',50,'Black')
choose_white_text = Text((center_x,80), 'Which player will be white?', 'Hunger Games',20,'Black')
game_will_start_text = Text((center_x,400), 'Game will start once chosen', 'Hunger Games',20,'Black')
white_timer=Text((20,40), '', None, 50,'White')
black_timer=Text((690,40), '', None, 50,'Black')
black_wins_text=Text((center_x,100), 'Black Wins!', 'Hunger Games', 30,'Black')
white_wins_text=Text((center_x,100), 'White Wins!', 'Hunger Games', 30,'White')
win_text=[white_wins_text,black_wins_text]
draw_text=Text((center_x,100), 'Draw!', 'Hunger Games', 30,'Grey')

all_texts=[mm_title]

## Buttons
# Main Menu Buttons
easy_button=Button((center_x,100),'Easy','Hunger Games',20,'Black',button_func)
blitz_button=Button((center_x,175),'Blitz','Hunger Games',20,'Black',button_func)
bullet_button=Button((center_x,250),'Bullet','Hunger Games',20,'Black',button_func)
p1_stat_button=Button((center_x,325),'Player 1','Hunger Games',20,'Black',button_func)
p2_stat_button=Button((center_x,400),'Player 2','Hunger Games',20,'Black',button_func)

# Pregame
select_white_button=Button((center_x-200,200),'P1','Hunger Games',20,'Black',button_func)
select_black_button=Button((center_x+200,200),'P2','Hunger Games',20,'Black',button_func)

# During Game
resign_button_white=Button((100,400),'White Resign','Hunger Games',15,'Black',button_func)
draw_button_white=Button((100,460),'White Offer Draw','Hunger Games',10,'Black',button_func)
resign_button_black=Button((760,400),'Black Resign','Hunger Games',15,'Black',button_func)
draw_button_black=Button((760,460),'Black Offer Draw','Hunger Games',10,'Black',button_func)

black_side_accept=Button((760,460-200),'Accept','Hunger Games',20,'Black',button_func)
black_side_decline=Button((760,460-140),'Decline','Hunger Games',20,'Black',button_func)

white_side_accept=Button((100,460-200),'Accept','Hunger Games',20,'Black',button_func)
white_side_decline=Button((100,460-140),'Decline','Hunger Games',20,'Black',button_func)

# End Game Buttons
restart_button=Button((100,300),'Restart','Hunger Games',20,'Black',button_func)
main_menu_button=Button((760,300),'Main Menu','Hunger Games',20,'Black',button_func)

# Others
back_button=Button((center_x+300,425),'Back','Hunger Games',20,'Black',button_func)

# Pawn Promotion
knight_button=Button((center_x,100),'Knight','Hunger Games',20,'Black',button_func)
bishop_button=Button((center_x,200),'Bishop','Hunger Games',20,'Black',button_func)
rook_button=Button((center_x,300),'Rook','Hunger Games',20,'Black',button_func)
queen_button=Button((center_x,400),'Queen','Hunger Games',20,'Black',button_func)

all_buttons=[easy_button, blitz_button,bullet_button,p1_stat_button,p2_stat_button]

# Game features
cur_game_active=0

#Player
p1=Player(1)
p2=Player(2)

while True:

    # Handles Quit and Timer Events
    for event in pg.event.get():
        if event.type == pg.QUIT:
            pg.quit()
            exit()
        elif event.type == timer_event and cur_game_active and cur_game.pause==False:
            check_timers()

    # Displays Background and Current Game
    screen.blit(mm_bg,mm_bg_rect)
    if cur_game_active:
        cur_game.load_board()
        if cur_game.pause==False:
            cur_game.check_highlight_click()
            cur_game.check_piece_click()               
    
    # Displays all Buttons and Texts
    check_buttons()
    check_texts()

    # Update Screen
    pg.display.update()
    clock.tick(60)

