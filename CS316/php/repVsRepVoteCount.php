<?php


		//get representative 1
		$rep1First = $_POST['rep1First'];
		$rep1Last = $_POST['rep1Last'];

		//get representative 2
		$rep2First = $_POST['rep2First'];
		$rep2Last = $_POST['rep2Last'];

		$dbconn = pg_connect("dbname=us_congress host=localhost user=postgres password=kushal941")
    				or die('Could not connect: ' . pg_last_error());

    	$agree_arr = array();
    	$disagree_arr = array();
    	$agreeWithPres_arr = array();
    	$disagreeWithPres_arr = array();

$agreeSQL = "SELECT COUNT(*) AS agreedCount, EXTRACT (YEAR FROM p1votes.date) AS YEAR, (p1votes.first_name || ' ' || p1votes.last_name) AS Person1, (p2votes.first_name || ' ' || p2votes.last_name) AS Person2
			FROM
					(((SELECT first_name, last_name, vote_id, vote
					FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
					WHERE first_name = '".$rep1First."' AND last_name = '".$rep1Last."') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
								JOIN 
									((SELECT first_name, last_name, vote_id, vote
									FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
									WHERE first_name = '".$rep2First."' AND last_name = '".$rep2Last."') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
								ON p1votes.vote_id = p2votes.vote_id AND
								   p1votes.vote = p2votes.vote)
			GROUP BY YEAR, Person1, Person2";

			$result1 = pg_query($dbconn, $agreeSQL) or die('Query failed: ' . pg_last_error());

			while ($line = pg_fetch_row($result1)) {
    				array_push($agree_arr, intval($line[0]));
			}

	pg_free_result($result1);		

$disagreeSQL = "SELECT COUNT(*) AS disagreedCount, EXTRACT (YEAR FROM p1votes.date) AS YEAR, (p1votes.first_name || ' ' || p1votes.last_name) AS Person1, (p2votes.first_name || ' ' || p2votes.last_name) AS Person2
			FROM
					(((SELECT first_name, last_name, vote_id, vote
					FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
					WHERE first_name = '".$rep1First."' AND last_name = '".$rep1Last."') p1 JOIN votes ON p1.vote_id = votes.id) p1votes
								JOIN 
									((SELECT first_name, last_name, vote_id, vote
									FROM (persons JOIN person_votes ON persons.id = person_votes.person_id)
									WHERE first_name = '".$rep2First."' AND last_name = '".$rep2Last."') p1 JOIN votes ON p1.vote_id = votes.id) p2votes
								ON p1votes.vote_id = p2votes.vote_id AND
								   p1votes.vote <> p2votes.vote      AND
								   (p1votes.vote <> 'Not Voting' OR
								   	p2votes.vote <> 'Not Voting'))
			GROUP BY YEAR, Person1, Person2";

			$result2 = pg_query($dbconn, $disagreeSQL) or die('Query failed: ' . pg_last_error());

			while ($line = pg_fetch_row($result2)) {
    				array_push($disagree_arr, intval($line[0]));
			}

			pg_free_result($result2);

$presAgreeSQL = "SELECT                                                
EXTRACT(year FROM date) as year, first_name,last_name,count(id) as agreeCount
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
WHERE first_name = '".$rep1First."' and last_name = '".$rep1Last."'
GROUP BY first_name, middle_name, last_name, year";		

			$result3 = pg_query($dbconn, $presAgreeSQL) or die('Query failed: ' . pg_last_error());

			while ($line = pg_fetch_row($result3)) {
    				array_push($agreeWithPres_arr, intval($line[3]));
			}

			pg_free_result($result3);

$presDisagreeSQL = "SELECT                                                
EXTRACT(YEAR FROM date) AS year, first_name,last_name,count(id) as disagreeCount
FROM                                    
	(SELECT foo.id, position, vote, person_id, first_name, middle_name, last_name, date
	FROM                      
		(SELECT bar.id, position, person_id, vote, date
		FROM 
			(SELECT * 
			  FROM presidential_support JOIN votes
			  ON votes.chamber = presidential_support.chamber and votes.number = presidential_support.vote_number and presidential_support.session = votes.session
			 )AS bar
		JOIN person_votes
		ON id = vote_id AND ((vote = 'Yea' and position = 'against') OR (vote = 'Nay' and position = 'support'))
		) AS foo
	JOIN persons
	ON person_id = persons.id
	) AS bob                                             
WHERE first_name = '".$rep1First."' and last_name = '".$rep1Last."'
GROUP BY first_name, middle_name, last_name, EXTRACT(YEAR FROM date)";

			$result4 = pg_query($dbconn, $presDisagreeSQL) or die('Query failed: ' . pg_last_error());

			while ($line = pg_fetch_row($result4)) {
    				array_push($disagreeWithPres_arr, intval($line[3]));
			}

			pg_free_result($result4);

			$resultArray = array($agree_arr, $disagree_arr, $agreeWithPres_arr, $disagreeWithPres_arr);

			echo json_encode($resultArray);

pg_close($dbconn);

?>
