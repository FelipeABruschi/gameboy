pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- labirinto
-- jogo de labirinto para pico-8
-- setas: mover | z (btn 4): reiniciar apos vencer

rw=7
rh=7
gw=0
gh=0
grid={}
px=0
py=0
t=0
won=false

function _init()
 init_game()
end

function init_game()
 gen_maze()
 px=0
 py=0
 t=0
 won=false
end

function gen_maze()
 gw=rw*2+1
 gh=rh*2+1
 grid={}
 for x=0,gw-1 do
  grid[x]={}
  for y=0,gh-1 do
   grid[x][y]=1
  end
 end

 local visited={}
 for x=0,rw-1 do
  visited[x]={}
  for y=0,rh-1 do
   visited[x][y]=false
  end
 end

 local stack={{0,0}}
 visited[0][0]=true
 grid[1][1]=0

 while #stack>0 do
  local cur=stack[#stack]
  local cx=cur[1]
  local cy=cur[2]
  local dirs={{1,0},{-1,0},{0,1},{0,-1}}
  local neigh={}
  for i=1,4 do
   local nx=cx+dirs[i][1]
   local ny=cy+dirs[i][2]
   if nx>=0 and nx<rw and ny>=0 and ny<rh and not visited[nx][ny] then
    add(neigh,{nx,ny,dirs[i][1],dirs[i][2]})
   end
  end
  if #neigh>0 then
   local n=neigh[flr(rnd(#neigh))+1]
   local nx=n[1]
   local ny=n[2]
   local dx=n[3]
   local dy=n[4]
   local gx1=cx*2+1
   local gy1=cy*2+1
   local gx2=nx*2+1
   local gy2=ny*2+1
   grid[gx1+dx][gy1+dy]=0
   grid[gx2][gy2]=0
   visited[nx][ny]=true
   add(stack,{nx,ny})
  else
   deli(stack,#stack)
  end
 end
end

function trymove(dx,dy)
 local nx=px+dx
 local ny=py+dy
 if nx<0 or nx>=rw or ny<0 or ny>=rh then return end
 local wx=px*2+1+dx
 local wy=py*2+1+dy
 if grid[wx][wy]==0 then
  px=nx
  py=ny
 end
end

function _update()
 if not won then
  t+=1
  if btnp(0) then trymove(-1,0) end
  if btnp(1) then trymove(1,0) end
  if btnp(2) then trymove(0,-1) end
  if btnp(3) then trymove(0,1) end
  if px==rw-1 and py==rh-1 then
   won=true
  end
 else
  if btnp(4) then
   init_game()
  end
 end
end

function _draw()
 cls(0)
 for gx=0,gw-1 do
  for gy=0,gh-1 do
   if grid[gx][gy]==1 then
    rectfill(gx*8,gy*8+8,gx*8+7,gy*8+15,1)
   end
  end
 end

 local egx=(rw-1)*2+1
 local egy=(rh-1)*2+1
 circfill(egx*8+4,egy*8+8+4,3,11)

 local pgx=px*2+1
 local pgy=py*2+1
 circfill(pgx*8+4,pgy*8+8+4,3,12)

 rectfill(0,0,127,7,5)
 print("tempo:"..flr(t/30).."s",2,1,7)

 if won then
  rectfill(14,55,113,75,0)
  rect(14,55,113,75,7)
  print("voce venceu!",34,60,11)
  print("tempo: "..flr(t/30).."s",34,66,7)
  print("z para jogar de novo",22,72,6)
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
