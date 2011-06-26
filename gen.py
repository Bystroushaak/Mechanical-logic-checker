#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# NONAME v0.0.0 (dd.mm.yy) by Bystroushaak (bystrousak@kitakitsune.org)
# This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 
# Unported License (http://creativecommons.org/licenses/by-nc-sa/3.0/cz/).
# Created in §Editor text editor.
#
#   Pokud hodlate pouzivat tento script, byl bych rad za zpetnou vazbu v podobe kratkeho informacniho 
#   emailu (napriklad maly popis kde budete script vyuzivat, nebo jen zminku o tom ze script pouzivate).
#   U vetsiny scriptu co jsem stvoril totiz nemam tuseni jestli upadly do zapomeni, nebo jsou uzitecne 
#   i nekomu jinemu nez me. Diky.
#
#   If you want to use this script, I'd be happy if you drop me a small feedback message. For example 
#   something about where you use this script, or just a message that this script is useful for you.
#   For most of my scripts, I dont know if they are forgotten, or they are usefull for other people.
#   Thanks.
#   
#
# Notes:
    # 
#===============================================================================
# Imports ======================================================================
#===============================================================================
import random
import math
import subprocess
import copy

import code

#===============================================================================
# Variables ====================================================================
#===============================================================================



#===============================================================================
#= Functions & objects =========================================================
#===============================================================================
class circuit:
	def __init__(self, goal = [["Left", "Left", "Left", "Right"], ["Right", "Right", "Right", "Left"]]):
		self.inputs  = "igear : A r l r l\nigear : B r r l l\n\n"
		self.outputs = "\n\ngear : out\n\n# links\n\n"
		self.parts = []
		self.names = ["A", "B", "out"]
		self.connections = []
		self.goal = goal
		
		self.cc = False
		
		self.output = ""
		
		self.__createRandomCircuit()
		self.getCost()
		
	def getCost(self):
		if self.cc:
			return self.c
		
		part_n = len(self.parts)
		conn_n = len(self.connections)
		p = subprocess.Popen("./mlchk", stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
		
		output, stderr = p.communicate(self.__repr__())
		self.output = output
		
		scode = p.wait()
		
		if scode != 0:
			self.cc = True
			self.c = -100 - math.sqrt(abs(5 - part_n) + abs(10 - conn_n)) 
			return self.c
		else:
			out_n = self.__getOutCost(self.__parseOutput(output)) # from 0 to 4
			
		self.cc = True
		self.c = out_n - math.sqrt(abs(5 - part_n) + abs(10 - conn_n)) 
			
		return self.c
		
	def mutate(self):
		self.cc = False
		
		r = random.randint(0, 6)
		if r == 0: 
			self.__removeRandomPart()
		elif r == 1 or r == 5:
			self.__addRandomPart()
		elif r == 2 or r == 3 or r == 6:
			self.__joinRandomParts()
		elif r == 4:
			self.__removeRandomConnection()
			
	def merge(self, c2):
		self.cc = False
		
		self.parts += c2.parts[3:]
		self.names += c2.names[3:]
		self.connections += c2.connections[3:]
		
		if len(self.parts) > 5:
			for i in range(len(self.parts) / 2):
				self.__removeRandomPart()
			
		for i in range(len(self.connections) / 4):
			self.__removeRandomConnection()
			
		for i in range(len(self.parts) + 1 * 4):
			self.__joinRandomParts()
			
		for i in range(4):
			self.mutate()
	
	def __repr__(self):
		return self.inputs + "\n".join(self.parts) + self.outputs + "\n".join(map(lambda x: x[0] + " - " + x[1], self.connections)) + "\n\n#"+ "\n#".join(self.output.split("\n"))

	def __createRandomCircuit(self, r = 6):
		self.cc = False
		
		# create random parts
		for i in range(random.randint(0,  r) + 3):
			self.__addRandomPart()
		
		# join them randomly
		# inputs and outputs
		self.__joinRandomParts(0)
		self.__joinRandomParts(1)
		self.__joinRandomParts(2)
		
		# random parts
		for i in range(random.randint(0, len(self.names) * 2) + 3):
			self.__joinRandomParts()
			
	def __removeRandomConnection(self):
		if len(self.connections) <= 1:
			return
			
		self.cc = False
		
		del self.connections[random.randint(0, len(self.connections) - 1)]
			
	def __removeRandomPart(self):
		if len(self.parts) <= 1:
			return
			
		self.cc = False
		
		# remove random part
		tmp = self.parts[random.randint(0, len(self.parts) - 1)]
		tmp = tmp.split(":")[1].strip()
		
		self.parts = filter(lambda x: not x.endswith(tmp), self.parts)
		self.names = filter(lambda x: not x.startswith(tmp), self.names)
		self.connections = filter(lambda x: x[0] != tmp and x[1] != tmp, self.connections)
	
	def __addRandomPart(self):
		self.cc = False
		
		r = random.randint(0, 4)
		suffix = str(random.randint(0, 1000000))
		if r == 0 or r == 3:
			self.parts.append("gear : g" + suffix)
			self.names.append("g" + suffix)
		elif r == 1:
			self.parts.append("ldiode : ld" + suffix)
			self.names.append("ld" + suffix + ".in")
			self.names.append("ld" + suffix + ".out")
		elif r == 2:
			self.parts.append("rdiode : rd" + suffix)
			self.names.append("rd" + suffix + ".in")
			self.names.append("rd" + suffix + ".out")
			
	def __joinRandomParts(self, what = None):
		self.cc = False
		
		if what == None:
			what = self.names[random.randint(0, len(self.names) - 1)]
		else:
			what = self.names[what]
			
		self.connections.append([what, self.names[random.randint(0, len(self.names) - 1)]])

	def __getOutCost(self, output):		
		cost = 0
		bcost = 0
		
		for key in output.keys():
			if key != "inA" and key != "inB":
				for i in range(len(output[key])):
					if self.goal[0][i] == output[key][i]:# or self.goal[1][i] == output[key][i]:
						cost += 1
				if cost > bcost:
					bcost = cost
				cost = 0
		
		return bcost**4
		
	def __parseOutput(self, output):
		output = output.splitlines()
		result = {}
		tmp = []
		
		for line in output:
			tmp.append(line.split(","))
		
		cnt = 0
		for key in tmp[0]:
			if key.strip() != "":
				result[key.strip()] = []
				for line in tmp[1:]:
					result[key.strip()].append(line[cnt])
			cnt += 1
				
		return result


#===============================================================================
#= Main program ================================================================
#===============================================================================
bcost = -1000
cost = 0
cnt = 0
best = circuit()
best.parts = ["gear : xex", "gear : xux"]
best.names = best.names[3:] + ["xex"]
best.connections = [["xex", "A"], ["xex", "out"]]
best.cc = False

BLEN = 512

#~ code.interact(None, None, globals())


biotop = [best]
tmptop = []
for i in range(BLEN):
	biotop.append(circuit())

while cost <= 0:
	biotop = sorted(biotop, key=circuit.getCost)
	biotop.reverse()
	biotop = biotop[:BLEN / 2]
	
	if biotop[0].getCost() > best.getCost():
		best = copy.deepcopy(biotop[0])
		print "New best:"
		print
		print best
		print
		
	print "Generation", str(cnt)
	print "Best in generation:", str(best.getCost())
	print "Generation len:", len(biotop)
	
	for i in range(len(biotop)):
		if biotop[i].getCost() > 200:
			file = open(str(biotop[i].getCost()) + ".bio", "w")
			file.write(str(biotop[i]))
			file.close()

		tmptop.append(copy.deepcopy(biotop[i]))

		c = circuit()
		c.merge(biotop[i])
		tmptop.append(c)

		biotop[i].mutate()
		tmptop.append(copy.deepcopy(biotop[i]))
		biotop[i].mutate()
		tmptop.append(biotop[i])
		
		for i in range(5):
			biotop[i].mutate()
		tmptop.append(copy.deepcopy(biotop[i]))
		
		c = circuit()
		c.merge(biotop[i])
		tmptop.append(c)
		
	for x in range(BLEN / 8):
		tmptop.append(circuit())
	
	biotop = tmptop
	tmptop = []
	cnt += 1
	

print "After " + str(cnt) + " itterations:"
print c







