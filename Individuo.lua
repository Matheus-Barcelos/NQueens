local Individuo = {size=0};


function funcaoObjetivo(individuo,n)
    custo = 0
    for i=1,(n-1) do
      for j = i+1,n do
        if (j-i) == (math.abs(individuo[i]-individuo[j])) then
          custo = custo + 1
        end     
      end
    end 
    return custo
end


function Individuo:print()
  io.write(self.posicoes[1])
  for i = 2,Individuo.size do
    io.write(", ")
    io.write(self.posicoes[i])
  end
  io.write('\t')
  io.write(self.valorObjetivo)
  io.write('\n')
end


function Individuo:new_rand(n)
  new = {posicoes={},valorObjetivo=0}
  i = 1;
  while i ~= n+1 do
    new.posicoes[i] = math.random(1,n);
    j=1
    while j<i do
      if new.posicoes[i] == new.posicoes[j] then
        i = i-1
        break
      end
      j=j+1
    end
    i = i+1    
  end
  
  new.valorObjetivo=funcaoObjetivo(new.posicoes,n)

  setmetatable(new, self)
  self.__index = self
  Individuo.size=n
  return new
end

function Individuo:new_pos(p)
  new = {posicoes={},valorObjetivo=0}
  
  for i = 1,table.getn(p) do
    new.posicoes[i] = p[i]
  end
  
  new.valorObjetivo=funcaoObjetivo(new.posicoes,table.getn(p))
  
  setmetatable(new, self)
  self.__index = self
  
  return new
end

function Individuo:new_pos_copy(i)
  new = {posicoes={},valorObjetivo=0}
  
  for j = 1,table.getn(i.posicoes) do
    new.posicoes[j] = i.posicoes[j]
  end
  
  
  new.valorObjetivo = i.valorObjetivo
  
  setmetatable(new, self)
  self.__index = self
  
  return new
end

function Individuo:swap(p1,p2)
  list = {}
  for i = 1,table.getn(self.posicoes) do
    list[i] = self.posicoes[i]
  end
  aux = list[p1]
  list[p1] = list[p2]
  list[p2] = aux
  return Individuo:new_pos(list)
end


function Individuo:visinhoAleatorio()
  n1 = math.random(1,table.getn(self.posicoes))
  n2 = math.random(1,table.getn(self.posicoes))
  
  return self:swap(n1,n2)
  
end

function Individuo:melhorSucessor()
  sucessores={}
  
  n = math.random(1,table.getn(self.posicoes))
  for j = 1, table.getn(self.posicoes) do
    if n~=j then
      table.insert(sucessores, self:swap(n,j))
    end
  end
  min = sucessores[1]
  minv = sucessores[1].valorObjetivo
  i = 2
  while i <= table.getn(sucessores) do
    if minv > sucessores[i].valorObjetivo then
      min = sucessores[i]
      minv = sucessores[i].valorObjetivo
    end
    i = i + 1
  end
  return min
end



function Individuo:Mutacao()
  pos1 = math.random(1,table.getn(self.posicoes))
  pos2 = math.random(1,table.getn(self.posicoes))
  
  while(pos2==pos1)do
    pos2 = math.random(1,table.getn(self.posicoes))
  end
  
  aux = self.posicoes[pos1]
  self.posicoes[pos1] = self.posicoes[pos2]
  self.posicoes[pos2] = aux
  self.valorObjetivo = funcaoObjetivo(self.posicoes,table.getn(self.posicoes))
end
return Individuo;
--pmx
 
