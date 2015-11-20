
--Find the id of the first person based on first and last name


--TEST CASE: Person 1 is Sherrod Brown, Person 2 is Maria Cantwell 

--Code for agreed votes

SELECT (agreed::float/((agreed+disagreed)::float)) AS similarityScore, p1Name, p2Name
FROM	((SELECT COUNT(*) AS agreed, p1Name, p2Name
			FROM
					(((SELECT (first_name || ' ' || last_name) AS p1Name, vote_id, vote
					FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
					WHERE first_name = 'Sherrod' AND last_name = 'Brown') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
								JOIN 
									((SELECT (first_name || ' ' || last_name) AS p2Name, vote_id, vote
									FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
									WHERE first_name = 'Maria' AND last_name = 'Cantwell') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
								ON p1votes.vote_id = p2votes.vote_id AND
								   p1votes.vote = p2votes.vote) agreeVotes GROUP BY p1Name, p2Name) agreeCount

NATURAL JOIN

    (SELECT COUNT(*) AS disagreed, p1Name, p2Name
			FROM
					(((SELECT (first_name || ' ' || last_name) AS p1Name, vote_id, vote
					FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
					WHERE first_name = 'Sherrod' AND last_name = 'Brown') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
								JOIN 
									((SELECT (first_name || ' ' || last_name) AS p2Name, vote_id, vote
									FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
									WHERE first_name = 'Maria' AND last_name = 'Cantwell') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
								ON p1votes.vote_id = p2votes.vote_id AND
								   p1votes.vote <> p2votes.vote      AND
								   (p1votes.vote <> 'Not Voting' OR
								   	p2votes.vote <> 'Not Voting')) disagreeVotes GROUP BY p1Name, p2Name) disagreeCount);


SELECT (agreed::float/((agreed+disagreed)::float)) AS similarityScore, p1Name, p2Name
FROM	((SELECT COUNT(*) AS agreed, p1Name, p2Name
			FROM
					(((SELECT (first_name || ' ' || last_name) AS p1Name, vote_id, vote
					FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
					WHERE first_name = 'Sherrod' AND last_name = 'Brown') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
								JOIN 
									((SELECT (first_name || ' ' || last_name) AS p2Name, vote_id, vote
									FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
									) p1 JOIN votes ON p1.vote_id = votes.id) p2votes
								ON p1votes.vote_id = p2votes.vote_id AND
								   p1votes.vote = p2votes.vote) agreeVotes GROUP BY p1Name, p2Name) agreeCount

NATURAL JOIN

    (SELECT COUNT(*) AS disagreed, p1Name, p2Name
			FROM
					(((SELECT (first_name || ' ' || last_name) AS p1Name, vote_id, vote
					FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
					WHERE first_name = 'Sherrod' AND last_name = 'Brown') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
								JOIN 
									((SELECT (first_name || ' ' || last_name) AS p2Name, vote_id, vote
									FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
									) p1 JOIN votes ON p1.vote_id = votes.id) p2votes
								ON p1votes.vote_id = p2votes.vote_id AND
								   p1votes.vote <> p2votes.vote      AND
								   (p1votes.vote <> 'Not Voting' OR
								   	p2votes.vote <> 'Not Voting')) disagreeVotes GROUP BY p1Name, p2Name) disagreeCount)
		ORDER BY similarityScore DESC ;








