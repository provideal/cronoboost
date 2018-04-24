Cronoboost.monthly(->{ puts "Monthly was executed" })
Cronoboost.at(->{ puts "At was executed" }, Time.now - 5)
Cronoboost.every(->{ puts "Every was executed" }, 10)
