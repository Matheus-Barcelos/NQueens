local Individuo = require"Individuo" 
local Populacao = require"Populacao"

function Descida_de_encosta(e0)
Estado=e0
visinho = Estado:melhorSucessor()
while(Estado.valorObjetivo > visinho.valorObjetivo)do
  Estado = visinho
  Estado:print()
  visinho = Estado:melhorSucessor()
end
return Estado

end

function Simulated_annealing(S0)
T = table.getn(S0.posicoes)
Sot = S0
S = S0

while true do
  
  if T<0.0001 or Sot.valorObjetivo==0 then 
    return Sot
  end

  S = Sot:visinhoAleatorio()
  e = S.valorObjetivo - Sot.valorObjetivo
  
  if e<0 then
    Sot = S
  else
    r = math.random()
    if r < math.exp(-e/T) then
      Sot = S
    end
  end
  T = 0.999*T
end

end
