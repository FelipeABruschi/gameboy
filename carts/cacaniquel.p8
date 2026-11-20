pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- caれせa-nれとquel dos bichinhos

function _init()
 credits=100
 bet=5
 state="idle"
 msg=""
 factor=0
 win=0
 t=0

 symbols={
  {name="raposa",c=9,pay=4},
  {name="gato",c=6,pay=5},
  {name="coelho",c=7,pay=6},
  {name="coruja",c=4,pay=8},
  {name="urso",c=15,pay=12},
  {name="estrela",c=10,pay=30}
 }

 pool={}
 local w={12,9,6,4,3,2}
 for i=1,6 do
  for j=1,w[i] do add(pool,i) end
 end

 reels={1,1,1}
 spin_t={0,0,0}
 stopped={true,true,true}
end

function new_symbol()
 return pool[flr(rnd(#pool))+1]
end

function start_spin()
 if credits<bet then return end
 credits-=bet
 state="spin"
 win=0
 msg=""
 for i=1,3 do
  stopped[i]=false
  spin_t[i]=20+i*10
 end
end

function _update()
 t+=1
 if state=="idle" then
  if credits<bet then state="over" end
  if btnp(5) then start_spin() end

 elseif state=="spin" then
  for i=1,3 do
   if not stopped[i] then
    if t%2==0 then reels[i]=new_symbol() end
    spin_t[i]-=1
    if spin_t[i]<=0 then
     stopped[i]=true
     reels[i]=new_symbol()
    end
   end
  end
  if stopped[1] and stopped[2] and stopped[3] then
   check_win()
   state="result"
   t=0
  end

 elseif state=="result" then
  if t>20 then
   state="idle"
  end

 elseif state=="over" then
  if btnp(5) then
   credits=100
   state="idle"
  end
 end
end

function check_win()
 local a,b,c=reels[1],reels[2],reels[3]
 if a==b and b==c then
  if a==6 then
   factor=3
  else
   factor=2
  end
  win=bet*factor
  msg="voce venceu"
 else
  win=0
  factor=0
  msg="nao foi dessa vez..."
 end
 credits+=win
end

-->8
-- desenho dos bichinhos
function draw_animal(id,x,y)
 local s=symbols[id]
 local c=s.c
 if id==1 then draw_fox(x,y,c)
 elseif id==2 then draw_cat(x,y,c)
 elseif id==3 then draw_rabbit(x,y,c)
 elseif id==4 then draw_owl(x,y,c)
 elseif id==5 then draw_bear(x,y,c)
 elseif id==6 then draw_star(x,y,c)
 end
end

function draw_fox(x,y,c)
 line(x-9,y-6,x-4,y-12,c) line(x-4,y-12,x-1,y-4,c)
 line(x+9,y-6,x+4,y-12,c) line(x+4,y-12,x+1,y-4,c)
 circfill(x,y,9,c)
 circfill(x-3,y-1,1,0)
 circfill(x+3,y-1,1,0)
 pset(x,y+4,0)
end

function draw_cat(x,y,c)
 line(x-8,y-9,x-3,y-3,c) line(x-8,y-9,x-2,y-6,c)
 line(x+8,y-9,x+3,y-3,c) line(x+8,y-9,x+2,y-6,c)
 circfill(x,y,8,c)
 circfill(x-3,y-1,1,0)
 circfill(x+3,y-1,1,0)
 line(x-8,y+3,x-2,y+2,8)
 line(x+8,y+3,x+2,y+2,8)
end

function draw_rabbit(x,y,c)
 ovalfill(x-5,y-18,x-2,y-6,c)
 ovalfill(x+2,y-18,x+5,y-6,c)
 circfill(x,y,8,c)
 circfill(x-3,y-1,1,0)
 circfill(x+3,y-1,1,0)
 pset(x,y+3,8)
end

function draw_owl(x,y,c)
 circfill(x,y,9,c)
 circfill(x-4,y-2,4,7)
 circfill(x+4,y-2,4,7)
 circfill(x-4,y-2,2,0)
 circfill(x+4,y-2,2,0)
 line(x-2,y+4,x,y+6,9)
 line(x+2,y+4,x,y+6,9)
end

function draw_bear(x,y,c)
 circfill(x-7,y-8,3,c)
 circfill(x+7,y-8,3,c)
 circfill(x,y,9,c)
 circfill(x-3,y-1,1,0)
 circfill(x+3,y-1,1,0)
 circfill(x,y+4,2,15)
end

function draw_star(x,y,c)
 for i=0,4 do
  local a=i/5-0.25
  local x2=x+cos(a)*10
  local y2=y+sin(a)*10
  line(x,y,x2,y2,c)
 end
 circfill(x,y,3,c)
end

-->8
-- interface
function _draw()
 cls(12)
 rectfill(0,110,127,127,3)
 rectfill(10,20,117,90,5)
 rectfill(14,24,113,86,1)

 for i=1,3 do
  local x=30+(i-1)*34
  draw_animal(reels[i],x,55)
 end

 if state=="idle" then
  print("botao x para girar",22,100,7)
 elseif state=="spin" then
  print("girando...",44,100,10)
 elseif state=="result" then
  print(msg,64-#msg*2,100,10)
  if factor>0 then
   print("fator: "..factor,64-10,110,10)
  end
 elseif state=="over" then
  print("fichas acabaram!",30,50,8)
  print("x para reiniciar",30,60,7)
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
