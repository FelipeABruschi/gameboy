pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- labirinto
-- jogo de labirinto para pico-8
-- setas: mover | z (btn 4): reiniciar apos vencer
 
-- tamanho do labirinto (em celulas)
rw=14
rh=14
-- tamanho de cada bloco em pixels
ts=4
 
-- dificuldade
-- bias: 0 a 1. perto de 1 = corredores longos
-- e sinuosos; perto de 0 = muitos becos curtos
bias=0.6
-- quantos labirintos candidatos gerar
-- (o mais dificil e escolhido)
tries=15
 
gw=0
gh=0
ox=0
oy=0
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
 
-- gera varios labirintos e fica
-- com o mais enganoso
function gen_maze()
 gw=rw*2+1
 gh=rh*2+1
 
 -- centraliza o mapa na area abaixo da barra de tempo
 ox=flr((128-gw*ts)/2)
 oy=8+flr((120-gh*ts)/2)
 
 local bestscore=-1
 local bestseed=0
 for i=1,tries do
  local seed=rnd(32767)
  srand(seed)
  gen_one()
  local s=score_maze()
  if s>bestscore then
   bestscore=s
   bestseed=seed
  end
 end
 
 -- recria o melhor a partir da semente
 srand(bestseed)
 gen_one()
end
 
-- gera um labirinto perfeito (growing tree)
function gen_one()
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
 
 local list={{0,0}}
 visited[0][0]=true
 grid[1][1]=0
 
 while #list>0 do
  -- mistura "ultima celula" (corredor
  -- longo) com "celula aleatoria"
  -- (ramificacao)
  local idx
  if rnd()<bias then
   idx=#list
  else
   idx=flr(rnd(#list))+1
  end
 
  local cur=list[idx]
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
   grid[cx*2+1+dx][cy*2+1+dy]=0
   grid[nx*2+1][ny*2+1]=0
   visited[nx][ny]=true
   add(list,{nx,ny})
  else
   deli(list,idx)
  end
 end
end
 
-- quantas saidas abertas uma celula tem
function exits(cx,cy)
 local dirs={{1,0},{-1,0},{0,1},{0,-1}}
 local n=0
 for i=1,4 do
  local nx=cx+dirs[i][1]
  local ny=cy+dirs[i][2]
  if nx>=0 and nx<rw and ny>=0 and ny<rh
  and grid[cx*2+1+dirs[i][1]][cy*2+1+dirs[i][2]]==0 then
   n+=1
  end
 end
 return n
end
 
-- pontua o labirinto atual:
-- + tamanho do caminho certo
-- + passos que se afastam da saida
-- + bifurcacoes ao longo do caminho
function score_maze()
 local dirs={{1,0},{-1,0},{0,1},{0,-1}}
 local par={}
 par[0]=-1
 local q={{0,0}}
 local head=1
 while head<=#q do
  local c=q[head]
  head+=1
  local cx=c[1]
  local cy=c[2]
  for i=1,4 do
   local nx=cx+dirs[i][1]
   local ny=cy+dirs[i][2]
   if nx>=0 and nx<rw and ny>=0 and ny<rh then
    local id=ny*rw+nx
    if par[id]==nil
    and grid[cx*2+1+dirs[i][1]][cy*2+1+dirs[i][2]]==0 then
     par[id]=cy*rw+cx
     add(q,{nx,ny})
    end
   end
  end
 end
 
 -- percorre o caminho da saida ate o inicio
 local id=(rh-1)*rw+rw-1
 local len=0
 local away=0
 local branches=0
 while id~=0 do
  local p=par[id]
  local cx=id%rw
  local cy=flr(id/rw)
  local pcx=p%rw
  local pcy=flr(p/rw)
  len+=1
  -- distancia ate a saida (antes e depois do passo)
  local dc=(rw-1-cx)+(rh-1-cy)
  local dp=(rw-1-pcx)+(rh-1-pcy)
  if dc>dp then away+=1 end
  local e=exits(cx,cy)
  if e>2 then branches+=e-2 end
  id=p
 end
 
 return len+away*2+branches
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
 
-- desenha um bloco da grade na posicao (gx,gy)
function tile(gx,gy,c)
 local x=ox+gx*ts
 local y=oy+gy*ts
 rectfill(x,y,x+ts-1,y+ts-1,c)
end
 
function _draw()
 cls(0)
 
 -- paredes
 for gx=0,gw-1 do
  for gy=0,gh-1 do
   if grid[gx][gy]==1 then
    tile(gx,gy,13)
   end
  end
 end
 
 -- saida (verde)
 tile((rw-1)*2+1,(rh-1)*2+1,11)
 
 -- jogador (azul)
 tile(px*2+1,py*2+1,12)
 
 -- barra de tempo
 rectfill(0,0,127,7,5)
 print("tempo:"..flr(t/30).."s",2,1,7)
 
 if won then
  local secs=flr(t/30)
  local fator=1
  if t<450 then fator=2 end
  rectfill(10,44,117,86,0)
  rect(10,44,117,86,7)
  cprint("voce venceu!",50,11)
  cprint("tempo: "..secs.."s",59,7)
  cprint("fator: "..fator,68,10)
  cprint("z para jogar de novo",77,7)
 end
end
 
-- imprime texto centralizado na tela
function cprint(s,y,c)
 print(s,64-#s*2,y,c)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
