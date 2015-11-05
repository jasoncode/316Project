SELECT                                                
EXTRACT(year FROM date) as year, first_name,last_name,count(id)
FROM                                    
	(SELECT foo.id, position, vote, person_id, first_name, middle_name, last_name,date 
	FROM                      
		(SELECT bar.id, position, person_id, vote, date
		FROM 
			(SELECT * 
			  FROM presidential_support JOIN votes
			  ON votes.chamber = presidential_support.chamber and votes.number = presidential_support.vote_number and presidential_support.session = votes.session
			 )AS bar
		JOIN person_votes
		ON id = vote_id AND ((vote = 'Yea' and position = 'support') OR (vote = 'Nay' and position = 'against'))
		) AS foo
	JOIN persons
	ON person_id = persons.id
	) AS bob                                             
WHERE first_name = 'Harry' and last_name = 'Reid'
GROUP BY first_name, middle_name, last_name, EXTRACT(YEAR from date);
