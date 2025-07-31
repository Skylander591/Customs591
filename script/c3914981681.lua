--Ria, the Demonic Angel
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)

	--Pendulum Effect: Special Summon this card if any monster has modified stats
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

-- Condition: Check if any monster has different Attribute, Race, Level, ATK, or DEF than original
function s.cfilter(c)
	return c:IsFaceup() and (
		c:GetAttribute()~=c:GetOriginalAttribute() or
		c:GetRace()~=c:GetOriginalRace() or
		c:GetLevel()~=c:GetOriginalLevel() or
		c:GetAttack()~=c:GetBaseAttack() or
		c:GetDefense()~=c:GetBaseDefense()
	)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		-- Prompt to choose between LIGHT Fiend or DARK Fairy
		local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2)) -- 0 = LIGHT Fiend, 1 = DARK Fairy
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(op==0 and ATTRIBUTE_LIGHT or ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)

		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(op==0 and RACE_FIEND or RACE_FAIRY)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end
