--Subjects agreed upon
				SELECT trim(both ' ' from subject) AS agreedSubjects
					FROM 
						(SELECT voteID, bill_id
							FROM 
								(SELECT p1votes.vote_id AS voteID
									FROM 
										(((SELECT first_name, last_name, vote_id, vote
										FROM 
											(persons JOIN person_votes ON persons.id = person_votes.person_id)
										WHERE first_name = 'Mitch' AND last_name = 'McConnell') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
														JOIN 
															((SELECT first_name, last_name, vote_id, vote
																	FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
																	WHERE first_name = 'Maria' AND last_name = 'Cantwell') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
														ON p1votes.vote_id = p2votes.vote_id AND
								   						p1votes.vote = p2votes.vote)) agreedVotes JOIN votes_re_bills ON agreedVotes.voteID = votes_re_bills.vote_id) agreedBills NATURAL JOIN bills_subjects;