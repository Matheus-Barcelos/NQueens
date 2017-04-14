local Individuo = require"Individuo"
local Populacao = {}


function Populacao:new(n,s)
  populacao = {individuos={},max=n}
  
  for i = 1,n do
    populacao.individuos[i] = Individuo:new_rand(s)
  end
  
  sort(populacao)
  
  setmetatable(populacao, self)
  self.__index = self
  return populacao
end

function Populacao:printStats()
  soma=0
  for i =1,table.getn(self.individuos) do
    soma = self.individuos[i].valorObjetivo + soma
  end
  
  mean = soma/table.getn(self.individuos)
  var = 0
  for i = 1,table.getn(self.individuos) do
    e = self.individuos[i].valorObjetivo - mean
    var = var + e*e
  end
  var = var/table.getn(self.individuos)
  io.write(soma..","..mean..","..var..","..self.individuos[1].valorObjetivo.."\n")
  
end


function Populacao:print()
  soma=0
  for i =1,table.getn(self.individuos) do
    self.individuos[i]:print()
    soma = self.individuos[i].valorObjetivo + soma
  end
  
  mean = soma/table.getn(self.individuos)
  var = 0
  for i = 1,table.getn(self.individuos) do
    e = self.individuos[i].valorObjetivo - mean
    var = var + e*e
  end
  var = var/table.getn(self.individuos)
  print(soma, mean, var)
  
end

function quicksort(p,inicio,fim)
  i=inicio
  j=fim
  pivo = p[math.floor((i+j)/2)].valorObjetivo
  while (i<j) do
    while (p[i].valorObjetivo<pivo) do
      i = i+1
    end
    while (p[j].valorObjetivo>pivo) do
      j = j-1
    end
    if(i<=j) then
      aux = p[i]
      p[i]=p[j]
      p[j]=aux
      i = i+1
      j = j-1
    end
  end
  if(j>inicio) then
    quicksort(p,inicio,j)
  end
  if(i<fim) then
    quicksort(p,i,fim)
  end
end

function sort(p)
  quicksort(p.individuos,1,table.getn(p.individuos))
end

function Populacao:Selecao()
  soma = 0
  soma_cum = {}
  selecao = {}
  for i = 1,table.getn(self.individuos) do
     soma = soma + table.getn(self.individuos[i].posicoes)/self.individuos[i].valorObjetivo
     soma_cum[i]=soma
  end
  numC = math.random(1,table.getn(self.individuos))
  numC = numC*2
  for i = 1,numC do
    n = math.random(0,soma)
    j = 1
    while j<=table.getn(soma_cum) do
      if n<=soma_cum[j] then
        selecao[i] = j
        break
      end
      j=j+1
    end
  end
  return selecao
  
end

function Populacao:incluiIndividuo(i)
  self.individuos[table.getn(self.individuos)+1] = i
end



function quicksortC(v,inicio,fim)
  i=inicio
  j=fim
  pivo = v.peso[math.floor((i+j)/2)]
  while i<j do
    while v.peso[i]<pivo do
      i=i+1
    end
    while v.peso[j]>pivo do
      j= j-1
    end
    if(i<=j) then
    aux = v.peso[i]
    v.peso[i] = v.peso[j]
    v.peso[j] = aux
    
    aux = v.posicao[i]
    v.posicao[i] = v.posicao[j]
    v.posicao[j] = aux
    
    i = i+1
    j = j-1
    
    end
  end
  if(j>inicio) then
    quicksortC(v,inicio,j)
  end
  if(i<fim) then
    quicksortC(v,i,fim)
  end
end

function sortC(v)
  quicksortC(v,1,table.getn(v.posicao))
end

function Populacao:Cruzar(i1,i2)
  ni1 = {}
  ni2 = {}
  
  pos = math.floor((1+table.getn(i1.posicoes))/2)
  
  ax1 = {posicao={},peso={}}
  ax2 = {posicao={},peso={}}
  for i = 1,pos do
      ax1.posicao[i]=i1.posicoes[i]
      ax2.posicao[i]=i2.posicoes[i]
  end
  
  for i = 1,pos do
    for j = 1,table.getn(i2.posicoes) do
      if ax1.posicao[i] == i2.posicoes[j] then
        ax1.peso[i] = j
      end
      if ax2.posicao[i] == i1.posicoes[j] then
        ax2.peso[i] = j
      end
    end
  end
  
  sortC(ax1)
  sortC(ax2)
  
  j=1
  for i = 1,table.getn(i1.posicoes) do
      
    if(i<=pos)then
      ni1[i] = ax1.posicao[j]
      ni2[i] = ax2.posicao[j]
      j = j+1        
    else
      ni1[i]=i1.posicoes[i]
      ni2[i]=i2.posicoes[i]
    end
    
  
  end
  
  self:incluiIndividuo(Individuo:new_pos(ni1))
  self:incluiIndividuo(Individuo:new_pos(ni2))
  
end

function Populacao:Cruzamento()
  selecao = self:Selecao()
  p = 1
  while p <= table.getn(selecao) do
    self:Cruzar(self.individuos[selecao[p]] , self.individuos[selecao[p+1]])
    p = p+2
  end
end


function Populacao:SelecaoM()
  sort(self)
  soma = 0
  soma_cum = {}
  selecao = {}
  for i = 1,table.getn(self.individuos) do
     soma = soma + self.individuos[i].valorObjetivo*math.log(i)
     soma_cum[i]=soma
  end
  numC = math.random(1,table.getn(self.individuos))
  for i = 1,numC do
    n = math.random(0,soma)
    j = 2
    while j<=table.getn(soma_cum) do
      if n<=soma_cum[j] then
        selecao[i] = j
        break
      end
      j=j+1
    end
  end
  return selecao
  
end

function Populacao:Mutacao()
  selecao = self:SelecaoM()
  for i = 1,table.getn(selecao) do
    self.individuos[selecao[i]]:Mutacao()
  end
  
end

function Populacao:Reduz()
  sort(self)
  nova_populacao = {}
  
  for i = 1,self.max do
    nova_populacao[i] = self.individuos[i]
  end
  
  self.individuos = nova_populacao
  
end

function Populacao:fim()
  for i=1,table.getn(self.individuos) do
    if self.individuos[i].valorObjetivo == 0 then
      return self.individuos[i]
    end
  end
  return nil;
end

return Populacao
