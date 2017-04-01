module TestHelper
    MOVIES = [
        "Kobieta w błękitnej wodzie",
        "Węże w samolocie",
        "Całe szczęście",
        "Superman: Powrót",
        "Ja, ty i on",
        "Nocny słuchacz",
        "Dexter"]

    CRITICS = {
        "Lisa Rose" => { 
            "Kobieta w błękitnej wodzie" => 2.5,
            "Węże w samolocie" => 3.5,
            "Całe szczęście" => 3.0,
            "Superman: Powrót" => 3.5,
            "Ja, ty i on" => 2.5,
            "Nocny słuchacz" => 3.0 },
        "Lana Rose" => { 
            "Kobieta w błękitnej wodzie" => 2.5,
            "Węże w samolocie" => 3.5,
            "Całe szczęście" => 3.0,
            "Superman: Powrót" => 3.5,
            "Ja, ty i on" => 2.5,
            "Nocny słuchacz" => 3.0,
            "Dexter" => 3.5 },
        "Robert Rose" => { 
            "Kobieta w błękitnej wodzie" => 3.5,
            "Węże w samolocie" => 4.5,
            "Całe szczęście" => 4.0,
            "Superman: Powrót" => 4.5,
            "Ja, ty i on" => 3.5,
            "Nocny słuchacz" => 4.0 },
        "Gene Seymour" => { 
            "Kobieta w błękitnej wodzie" => 3.0,
            "Węże w samolocie" => 3.5,
            "Całe szczęście" => 1.5,
            "Superman: Powrót" => 5.0,
            "Nocny słuchacz" => 3.0,
            "Ja, ty i on" => 3.5 },
        "Bob Seymour" => { 
            "Kobieta w błękitnej wodzie" => 3.0,
            "Węże w samolocie" => 3.5,
            "Całe szczęście" => 1.5,
            "Superman: Powrót" => 5.0,
            "Nocny słuchacz" => 3.0,
            "Ja, ty i on" => 3.5,
            "Dexter" => 2.5 },
        "Michael Phillips" => { 
            "Kobieta w błękitnej wodzie" => 2.5,
            "Węże w samolocie" => 3.0,
            "Superman: Powrót" => 3.5,
            "Nocny słuchacz" => 4.0 },
        "Claudia Puig" => { 
            "Węże w samolocie" => 3.5,
            "Całe szczęście" => 3.0,
            "Nocny słuchacz" => 4.5,
            "Superman: Powrót" => 4.0,
            "Ja, ty i on" => 2.5 },
        "Mick LeSalle" => { 
            "Kobieta w błękitnej wodzie" => 3.0,
            "Węże w samolocie" => 4.0,
            "Całe szczęście" => 2.0,
            "Superman: Powrót" => 3.0,
            "Nocny słuchacz" => 3.0,
            "Ja, ty i on" => 2.0 },
        "Jack Matthews" => { 
            "Kobieta w błękitnej wodzie" => 3.0,
            "Węże w samolocie" => 4.0,
            "Nocny słuchacz" => 3.0,
            "Superman: Powrót" => 5.0,
            "Ja, ty i on" => 3.5 },
        "Toby" => { 
            "Węże w samolocie" => 4.5,
            "Ja, ty i on" => 1.0,
            "Superman: Powrót" => 4.0 },
        "Donald Trump" => {}
    }

    NONEXISTING_USER_1 = "Krzesło"
    NONEXISTING_USER_2 = "Lampa"
    EXISTING_USER_1 = "Lisa Rose"
    EXISTING_USER_1_WITH_MORE_RATED_MOVIES = "Lana Rose"
    EXISTING_USER_1_WITH_SCORES_SHIFTED_BY_CONSTANT = "Robert Rose"
    EXISTING_USER_2 = "Gene Seymour"
    EXISTING_USER_2_WITH_MORE_RATED_MOVIES = "Bob Seymour"
    EXISTING_USER_3 = "Michael Phillips"
    EXISTING_EMPTY_USER = "Donald Trump"
end
