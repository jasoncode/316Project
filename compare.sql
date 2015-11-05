
--Find the id of the first person based on first and last name


--TEST CASE: Person 1 is Sherrod Brown, Person 2 is Maria Cantwell 

--Code for agreed votes

	SELECT COUNT(p1votes.vote_id) AS agreed, EXTRACT (YEAR FROM p1votes.date) AS YEAR, p1votes.first_name, p1votes.last_name, p2votes.first_name, p2votes.last_name
			FROM
					(((SELECT first_name, last_name, vote_id, vote
					FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
					WHERE first_name = 'Sherrod' AND last_name = 'Brown') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
								JOIN 
									((SELECT first_name, last_name, vote_id, vote
									FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
									WHERE first_name = 'Maria' AND last_name = 'Cantwell') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
								ON p1votes.vote_id = p2votes.vote_id AND
								   p1votes.vote = p2votes.vote)
			GROUP BY EXTRACT (YEAR FROM p1votes.date), p1votes.first_name, p1votes.last_name, p2votes.first_name, p2votes.last_name;

--Code for disagreed votes
    SELECT COUNT(p1votes.vote_id) AS disagreed, EXTRACT (YEAR FROM p1votes.date) AS YEAR, p1votes.first_name, p1votes.last_name, p2votes.first_name, p2votes.last_name
			FROM
					(((SELECT first_name, last_name, vote_id, vote
					FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
					WHERE first_name = 'Sherrod' AND last_name = 'Brown') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
								JOIN 
									((SELECT first_name, last_name, vote_id, vote
									FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
									WHERE first_name = 'Maria' AND last_name = 'Cantwell') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
								ON p1votes.vote_id = p2votes.vote_id AND
								   p1votes.vote <> p2votes.vote      AND
								   (p1votes.vote <> 'Not Voting' OR
								   	p2votes.vote <> 'Not Voting'))
			GROUP BY EXTRACT (YEAR FROM p1votes.date), p1votes.first_name, p1votes.last_name, p2votes.first_name, p2votes.last_name;


--Subjects agreed upon
				SELECT subject AS agreedSubjects
					FROM 
						(SELECT voteID, bill_id
							FROM 
								(SELECT p1votes.vote_id AS voteID
									FROM 
										(((SELECT first_name, last_name, vote_id, vote
										FROM 
											(persons JOIN person_votes ON persons.id = person_votes.person_id)
										WHERE first_name = 'Sherrod' AND last_name = 'Brown') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
														JOIN 
															((SELECT first_name, last_name, vote_id, vote
																	FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
																	WHERE first_name = 'Maria' AND last_name = 'Cantwell') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
														ON p1votes.vote_id = p2votes.vote_id AND
								   						p1votes.vote = p2votes.vote)) agreedVotes JOIN votes_re_bills ON agreedVotes.voteID = votes_re_bills.vote_id) agreedBills NATURAL JOIN bills_subjects;


								    
SELECT subject AS disagreedSubjects
					FROM 
						(SELECT voteID, bill_id
							FROM 
								(SELECT p1votes.vote_id AS voteID
									FROM 
										(((SELECT first_name, last_name, vote_id, vote
										FROM 
											(persons JOIN person_votes ON persons.id = person_votes.person_id)
										WHERE first_name = 'Sherrod' AND last_name = 'Brown') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
														JOIN 
															((SELECT first_name, last_name, vote_id, vote
																	FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
																	WHERE first_name = 'Maria' AND last_name = 'Cantwell') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
														ON p1votes.vote_id = p2votes.vote_id AND
								   						p1votes.vote <> p2votes.vote      AND
								   						(p1votes.vote <> 'Not Voting' OR
								   						p2votes.vote <> 'Not Voting'))) disagreedVotes JOIN votes_re_bills ON disagreedVotes.voteID = votes_re_bills.vote_id) disagreedBills NATURAL JOIN bills_subjects;




