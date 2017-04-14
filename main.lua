require "AG"
require "Subida"
local Individuo = require"Individuo" 
local Populacao = require"Populacao"



local function main()
math.randomseed(os.time())

t=os.clock()
r=Simulated_annealing(Individuo:new_rand(64))
et = os.clock() - t
r:print()
print(et)
print()

t=os.clock()
r=AG_SA(250,64,50)
et = os.clock() - t
r:print()
print(et)
print()


t=os.clock()
r=Algoritmo_Genetico(250,64,50)
et = os.clock() - t
r:print()
print(et)
end
main()
