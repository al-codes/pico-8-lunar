

-- pico-8 cartridge

function _init()
	game_over=false 
	win=false
	g=0.025 --gravity 
	make_player()
	make_ground()
end

function _update()
	if (not game_over) then 
		move_player()
		check_land()
	else
		if (btnp(5)) then
			_init()
		end
	end
end

function _draw() 
	cls() 
	draw_stars()
	draw_ground()
	draw_player()
	
	if (game_over) then 
		if (win) then
  	print("you win!",48,48,11)
 	else
  	print("too bad!",48,48,8)
  end
		print("press ❎ to play again",20,70,5)
	end
end

function make_player() 
	p={}
	p.x=60 --position 
	p.y=8
	p.dx=0 --movement 
	p.dy=0
	p.sprite=1 
	p.alive=true 
	p.thrust=0.075
end

function draw_player() 
	spr(p.sprite,p.x,p.y)
	if (game_over and win) then
		spr(4,p.x,p.y-8) --flag 
	elseif (game_over) then
		spr(5,p.x,p.y) --explosion 
	end
end

function move_player() 
	p.dy+=g --add gravity
	thrust()
	p.x+=p.dx --actually move
	p.y+=p.dy --the player 
	
	stay_on_screen()
end

function thrust()
--add thrust to movement 	
	if (btn(0)) p.dx-=p.thrust 
	if (btn(1)) p.dx+=p.thrust 
	if (btn(2)) p.dy-=p.thrust
	
--thrust sound
 if (btn(0) or btn(1) or btn(2)) sfx(0)
end

function stay_on_screen()
	if (p.x<0) then --left side
		p.x=0
		p.dx=0 
	end
	if (p.x>119) then --right side p.x=119
		p.dx=0
	end
	if (p.y<0) then
		p.y=0
		p.dy=0 
	end
end

function rndb(low,high)
	return flr(rnd(high-low+1)+low)
end

function draw_stars() 
	srand(1)
	for i=1,50 do
  pset(rndb(0,127),rndb(0,127),rndb(5,7))
 	end
 srand(time())
end

function make_ground() --create the ground
	gnd={}
	local top=96 --highest point 
	local btm=120 --lowest point
	
--set up the landing pad 
	pad={}
	pad.width=15 
	pad.x=rndb(0,126-pad.width) 
	pad.y=rndb(top,btm) 
	pad.sprite=2
	
--create ground at pad
	for i=pad.x,pad.x+pad.width do
		gnd[i]=pad.y end
		
--create ground right of pad 
	for i=pad.x+pad.width+1,127 do
		local h=rndb(gnd[i-1]-3,gnd[i-1]+3)
  gnd[i]=mid(top,h,btm)
 end
 
--create ground left of pad 	
	for i=pad.x-1,0,-1 do
		local h=rndb(gnd[i+1]-3,gnd[i+1]+3)
 	gnd[i]=mid(top,h,btm)
 end
end

function draw_ground() 
	for i=0,127 do
  line(i,gnd[i],i,127,2)
 end
 spr(pad.sprite,pad.x,pad.y,2,1)
end

function check_land()
	l_x=flr(p.x) --left side of ship 
	r_x=flr(p.x+7) --right side of ship 
	b_y=flr(p.y+7) --bottom of ship
	
	over_pad=l_x>=pad.x and r_x<=pad.x+pad.width 
	on_pad=b_y>=pad.y-1
	slow=p.dy<1
	
	if (over_pad and on_pad and slow) then 
		end_game(true)
	elseif (over_pad and on_pad) then 
		end_game(false)
	else
		for i=l_x,r_x do
			if (gnd[i]<=b_y) end_game(false) 
		end
	end 
end

function end_game(won) 
	game_over=true 
	win=won
	
	if (win) then
  sfx(1)
	else 
		sfx(2)
	end
end