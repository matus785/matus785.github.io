module User exposing (..)

import Json.Encode as Enc exposing (..)
import Json.Decode as Dec exposing (..)
import Array exposing (..)

maxMapNumber : Int
maxMapNumber = 9


type Difficulty = 
    Easy 
    | Medium
    | Hard

type alias Score =  { 
    highestLives : Int  
    , bestTime : Float  -- time in miliseconds
    }

type alias User = { 
    username : String
    , levelScore : Array Score
    , difficulty : Difficulty
    }

noUser : User
noUser = { 
    username = "New player"
    , levelScore = Array.empty
    , difficulty = Medium
    }

------------------------------------------------
-- Difficulty
------------------------------------------------

diff_from_str: String -> Difficulty
diff_from_str str = 
    case str of
        "Easy" -> Easy
        "Medium" -> Medium
        "Hard" -> Hard
        _ -> Easy

diff_to_str : Difficulty -> String
diff_to_str diff = 
    case diff of 
        Easy -> "Easy"
        Medium  -> "Medium"
        Hard -> "Hard"

difficulty_enemy_multiplier : Difficulty -> Float
difficulty_enemy_multiplier difficulty = 
    case difficulty of 
        Easy -> 0.85
        Medium  -> 1
        Hard -> 1.1

difficulty_cost_multiplier : Difficulty -> Float
difficulty_cost_multiplier difficulty = 
    case difficulty of 
        Easy -> 0.9
        Medium  -> 1
        Hard -> 1.05

------------------------------------------------
-- Score
------------------------------------------------

emptyScore : Score
emptyScore = {highestLives = 0, bestTime = 0}

get_unlocked_level : User -> Int
get_unlocked_level user = 
    min maxMapNumber <| (Array.length user.levelScore) + 1

-- get_score => returns Score lives and time as String
get_score : Score -> (String, String)
get_score score = 
    let
        not_complete = score.highestLives == 0

        lives = 
            if not_complete then "✘"
            else String.fromInt score.highestLives

        totalTime = score.bestTime / 1000

        minutes = floor (totalTime / 60)
        seconds = remainderBy 60 (ceiling totalTime)
        
        time = 
            if not_complete then "✘"
            else if (minutes == 0) then String.fromInt seconds ++ " s"
            else String.fromInt minutes ++ " m : " ++ String.fromInt seconds ++ " s"
    in
    (lives, time)

-- get_medal => returns medal texture if level was complete
get_medal : Array Score -> Int -> Maybe String
get_medal scores levelNumber = 
    let
        lvlScore = Array.get (levelNumber - 1) scores

        lives =     
            case lvlScore of
                Nothing -> 0
                Just s -> s.highestLives
   
    in
    if (lives == 0) then Nothing
    else if (lives <= 8) then Just "/assets/ui/map/medal-bronze.png"
    else if (lives <= 16) then Just "/assets/ui/map/medal-silver.png"
    else if (lives <= 19) then Just "/assets/ui/map/medal-gold.png"
    else Just "/assets/ui/map/medal-perfect.png"

-- set_level => sets user score Array length to lvlNumber, fills unfinished levels with empty score
set_level : User -> Int -> User
set_level user lvlNumber = 
    let
        difference = lvlNumber - (get_unlocked_level user)

        newScore = 
            case (compare difference 0) of
                GT -> Array.append user.levelScore (Array.repeat difference emptyScore)
                EQ -> user.levelScore
                LT -> Array.slice 0 ((Array.length user.levelScore) + difference) user.levelScore
    in
    {user | levelScore = newScore}

-- compare_score => compares 2 scores and returns the best score (higher lives and lower time)
compare_score : Score -> Score -> Score
compare_score oldScore newScore = 
    let
        orderLives = compare oldScore.highestLives newScore.highestLives

        orderTime = compare oldScore.bestTime newScore.bestTime

        score = 
            case orderLives of 
                GT -> oldScore
                LT -> newScore
                EQ -> 
                    case orderTime of
                        LT -> oldScore
                        _ -> newScore
    in
    score

-- save_level_score => saves level score after level completion (uses compare_score)
save_level_score : User -> Int -> Int -> Float -> User
save_level_score user lvlNumber lives time = 
    let
        index = lvlNumber - 1
        oldScore = Array.get index user.levelScore

        newScore = Score lives time

        score = 
            case oldScore of
                -- level finished for the first time
                Nothing -> Array.push newScore user.levelScore
                -- compare existing score with a new score
                Just old -> Array.set index (compare_score old newScore) user.levelScore
    in
    {user | levelScore = score}

-- set_user_score => compares 2 users score Array and returns new user with the best scores
set_user_score : User -> User -> User
set_user_score oldUser newUser = 
    let 
        oldScore = Array.toList oldUser.levelScore
        newScore = Array.toList newUser.levelScore

        updatedScore = Array.fromList <| List.map2 (\old new -> compare_score old new) oldScore newScore

        difference = (Array.length newUser.levelScore) - (Array.length updatedScore)

        score = 
            -- keep last level score
            if (Array.length oldUser.levelScore == 9 && Array.length newUser.levelScore >= 8) then oldUser.levelScore
            -- fill empty score 
            else if (difference > 0) then Array.append updatedScore (Array.repeat difference emptyScore)

            else updatedScore
 
    in
    {newUser | levelScore = score}

user_not_changed : User -> User -> Bool
user_not_changed oldUser newUser = 
    let
        nameUnchanged = oldUser.username == newUser.username

        levelUnchanged = get_unlocked_level oldUser == get_unlocked_level newUser

        difficultyUnchanged = oldUser.difficulty == newUser.difficulty
    in
    nameUnchanged && levelUnchanged && difficultyUnchanged

------------------------------------------------
-- JSON encoder, decoders
------------------------------------------------

decode_difficulty : Dec.Decoder Difficulty
decode_difficulty =
    Dec.string |> Dec.andThen 
    (\str ->
        case str of
            "Easy" -> Dec.succeed Easy
            "Medium" -> Dec.succeed Medium
            "Hard" -> Dec.succeed Hard
            other -> Dec.fail <| "Unknown difficulty: " ++ other
    )

encode_user : User ->  Enc.Value
encode_user user =
    let 
        diff = diff_to_str user.difficulty
        listLives = Array.foldr (\o listL -> (o.highestLives) :: listL) [] user.levelScore
        listTimes = Array.foldr (\o listT -> (o.bestTime) :: listT) [] user.levelScore
    in 
    Enc.object 
    [ 
        ("username", Enc.string user.username)
        , ("lives", Enc.list Enc.int listLives)
        , ("times", Enc.list Enc.float listTimes)
        , ("difficulty", Enc.string diff)
    ]

decode_user : Dec.Decoder User
decode_user =
    let
        nameDecoder = Dec.field "username" Dec.string
        livesDecoder = Dec.field "lives" (Dec.list Dec.int)
        timesDecoder = Dec.field "times" (Dec.list Dec.float)
        difficultyDecoder = Dec.field "difficulty" decode_difficulty

        scoreDecoder = 
            Dec.map2 (\listL listT -> Array.fromList <| List.map2 (\lives time -> Score lives time) listL listT) livesDecoder timesDecoder
    in
    Dec.map3 User
        nameDecoder
        scoreDecoder
        difficultyDecoder
