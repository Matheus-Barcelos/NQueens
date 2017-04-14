local Individuo = require"Individuo" 
local Populacao = require"Populacao"
require"Subida"

function Algoritmo_Genetico(tam_pop, N)
--  io.write("Gerando População inicial: ")
  P = Populacao:new(tam_pop,N)
--  print("ok")
  ite = 0
--  io.write(ite..",")
--  P:printStats()
  while(P.individuos[1].valorObjetivo~=0) do
    ite = ite+1
    P:Cruzamento()
    P:Mutacao()
    P:Reduz()
--    io.write(ite..",")
--    P:printStats()
  end
  print (ite)
  return P.individuos[1]  
end

function AG_Descida_de_Encosta(tam_pop,N,max_ite)
--  io.write("Gerando População inicial: ")
  P = Populacao:new(tam_pop,N)
--  print("ok")
  ite = 0
--  io.write(ite..",")
--  P:printStats()
  while(P.individuos[1].valorObjetivo~=0) and ite<max_ite do
    ite = ite+1
    P:Cruzamento()
    P:Mutacao()
    P:Reduz()
--    io.write(ite..",")
--    P:printStats()
  end
  if (P.individuos[1].valorObjetivo==0) then
    print(ite)
    return P.individuos[1]
  else
    t = 1
    minr = P.individuos[1]
    repeat
      r = Descida_de_encosta(P.individuos[t])
      if r.valorObjetivo == 0 then
        return r
      end
      if r.valorObjetivo < minr.valorObjetivo then
        minr=r
      end
      r:print()
      t = t+1
    until t>table.getn(P.individuos)
  end
  
  
end

function AG_SA(tam_pop,N,max_ite)
--  io.write("Gerando População inicial: ")
  P = Populacao:new(tam_pop,N)
--  print("ok")
  ite = 0
--  io.write(ite..",")
--  P:printStats()
  while(P.individuos[1].valorObjetivo~=0) and ite<max_ite do
    ite = ite+1
    P:Cruzamento()
    P:Mutacao()
    P:Reduz()
--    io.write(ite..",")
--    P:printStats()
  end
  if (P.individuos[1].valorObjetivo==0) then
    print(ite)
    return P.individuos[1]
  else
    t = 1
    minr = P.individuos[1]
    repeat
      r = Simulated_annealing(P.individuos[t])
      if r.valorObjetivo == 0 then
        return r
      end
      if r.valorObjetivo < minr.valorObjetivo then
        minr=r
      end
      t = t+1
    until t>table.getn(P.individuos)
  end
  
  
end

