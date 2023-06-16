 --- understanding consumer behaviour ---
 
select distinct Consume_reason, Consume_time, count(consume_time) as no_of_responses_
from comp.responses
where Consume_reason not in ("Other")
group by consume_time, consume_reason
Order by consume_reason;

 --- consumption Rate --
 
Select 
dim_repondents.age , dim_repondents.gender, 
consume_frequency, count(Consume_frequency) as consumption_rate
from comp.responses
left Join comp.dim_repondents
on dim_repondents.Respondent_ID = responses.Respondent_ID
group by age, gender, Consume_frequency
Order by age, Consume_frequency;

 --- Preferences of consumers ----
 
select
age, current_brands, consume_frequency, count(current_brands) as number_of_drinkers
from responses
Join dim_repondents
on dim_repondents.Respondent_ID = responses.Respondent_ID
where consume_frequency not in ("rarely") and Current_brands not in ("Others")
group by age, current_brands, consume_frequency
order by age, current_brands, consume_frequency;

 ---- Health concerned drinkers ---

select consume_frequency, count(Health_concerns) as health_concerned_ppl
from responses
where Health_concerns = "yes"
group by consume_frequency, Health_concerns
order by consume_frequency, Health_concerns ;

 --- Ingredients expected by health concerned people and their frequecy to drink --- 
  
with total_responses as 
(select count(Respondent_ID) as responses_ from responses)

select consume_frequency, count((Health_concerns)/(total_responses.responses_)) as health_concerned_ppl, Ingredients_expected
from responses 
Join total_responses
where Health_concerns = "yes" and 
(Consume_frequency ="Once a week" or Consume_frequency ="2-3 times a week" or Consume_frequency ="Daily")
group by consume_frequency, Ingredients_expected
order by consume_frequency, Ingredients_expected ;