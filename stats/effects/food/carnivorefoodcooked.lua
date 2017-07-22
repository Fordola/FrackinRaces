function init()
  self.movementParams = mcontroller.baseParameters()  
  local bounds = mcontroller.boundBox()
  self.protectionBonus = config.getParameter("protectionBonus", 0)
  baseValue = config.getParameter("healthBonus",0)*(status.resourceMax("health"))
  baseValue2 = config.getParameter("energyBonus",0)*(status.resourceMax("energy"))
  self.tickDamagePercentage = 0.006
  self.tickTime = 2
  self.tickTimer = self.tickTime
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
  script.setUpdateDelta(5)
end

function update(dt)
	 if not status.stat("isHerbivore") or status.stat("isHerbivore")==0 then
	   if (self.tickTimer <= 0) then
	      self.tickTimer = self.tickTime
	      status.applySelfDamageRequest({
		damageType = "IgnoresDef",
		damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
		damageSourceKind = "poison",
		sourceEntityId = entity.id()
	      })
	      effect.setParentDirectives("fade=806e4f="..self.tickTimer * 0.25) 
	   else
	     self.tickTimer = self.tickTimer - dt
	   end
	 elseif status.stat("isCarnivore") then
	    applyEffects()   
	 end
end

function applyEffects()
    status.setPersistentEffects("floranpower1", {
      {stat = "protection", amount = self.protectionBonus},
      {stat = "maxHealth", amount = baseValue },
      {stat = "maxEnergy", amount = baseValue2 }
    })
end

function uninit()
    status.clearPersistentEffects("floranpower1")
end