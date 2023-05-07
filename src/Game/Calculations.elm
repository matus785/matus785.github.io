module Game.Calculations exposing (..)

------------------------------------------------
-- Rotation MATRIX used:
-- X [+ cos A , + sin A]
-- Y [- sin A , + cos A]
------------------------------------------------

type Direction = 
    Up 
    | Right
    | Down
    | Left


type alias Point = {
    posXY : (Float, Float)
    , direction : Direction -- value of enemy rotation required to arrive at posXY
    }

emptyPoint : Point 
emptyPoint = Point (0, 0) Up

dir_to_rot : Direction -> Float
dir_to_rot dir = 
    let
        deg = 
            case dir of
                Up -> 0
                Right -> 90
                Down -> 180
                Left -> 270
    in
    deg * (pi / 180)

rot_to_dir : Float -> Direction
rot_to_dir rot = 
    let
        deg = rot * (180 / pi)
    in
    case (round deg) of
        0 -> Up
        90 -> Right
        180 -> Down
        270 -> Left
        _ -> Up

rot_is_dir : Float -> Bool
rot_is_dir rot = 
    let
        deg = rot * (180 / pi)
    in
    case (round deg) of
        0 -> True
        90 -> True
        180 -> True
        270 -> True
        _ -> False

-- get_previous_point => returns X,Y position that is roughly 1 tile before point
-- used for rendering road flag on map
get_previous_point : Maybe Point -> (Float, Float)
get_previous_point point  =
    let
        currentPoint = Maybe.withDefault (Point (0, 0) Up) point

        posX = Tuple.first currentPoint.posXY
        posY = Tuple.second currentPoint.posXY

        newX = 
            case currentPoint.direction of
                Right -> posX - 1
                Left -> posX + 0.2
                _ -> posX - 0.4

        newY = 
            case currentPoint.direction of
                Up -> posY - 1
                Down -> posY + 0.2
                _ -> posY - 0.4
    in
    (newX, newY)

-- out_of_map => returns TRUE if point is NOT inside map with specified height and width, otherwise FALSE
out_of_map : (Float, Float) -> (Int, Int) -> Bool
out_of_map (x, y) (row, col) = 
    let
        maxX = toFloat col
        maxY = toFloat row
    in
    if (x < 0 || x > maxX || y < 0 || y > maxY ) then True
    else False

distance_of_2points : (Float, Float) -> (Float, Float) -> Float
distance_of_2points (x1, y1) (x2, y2) = 
    let
        distanceX = (x2 - x1) ^ 2 
        distanceY = (y2 - y1) ^ 2
    in
    sqrt (distanceX + distanceY)

rotation_of_2points : (Float, Float) -> (Float, Float) -> Float
rotation_of_2points (x1, y1) (x2, y2) =
    let
        newX = x2 - x1
        newY = y2 - y1
    in
    atan2 newX newY


-- compare_distances => Order function for 2 Maybe Float numbers
-- Nothing > number | Nothing == Nothing | Otherwise (compare dist1 dist2)
compare_distances : Maybe Float -> Maybe Float -> Order
compare_distances dist1 dist2 =
    case dist1 of
        Nothing ->
            case dist2 of 
                Nothing -> EQ
                _ -> GT

        Just d1 ->
            case dist2 of 
                Nothing -> LT
                Just d2 -> compare d1 d2

------------------------------------------------
-- Collision detection algorithms
------------------------------------------------

{-
-- rectangle_collision => returns TRUE if 2 axis aligned rectangles are colliding, otherwise FALSE
rectangle_collision : (Float, Float) -> (Float, Float) -> (Float, Float) -> (Float, Float) -> Bool
rectangle_collision (x1, y1) (w1, h1) (x2, y2) (w2, h2) =
    let
        width1 = (w1/2)
        height1 = (h1/2)

        width2 = (w2/2)
        height2 = (h2/2)

        r1 = x1 + width1
        l1 = x1 - width1
        u1 = y1 + height1
        d1 = y1 - height1
        r2 = x2 + width2
        l2 = x2 - width2
        u2 = y2 + height2
        d2 = y2 - height2
    in
    r1 >= l2 && r2 >= l1 && u1 >= d2 && u2 >= d1
-}

----------------------------------------------------------------------------------------------------------------
-- collision_2rectangles and its helper functions were created based on code from following websites: 
-- https://stackoverflow.com/questions/62028169/how-to-detect-when-rotated-rectangles-are-colliding-each-other
-- https://github.com/ArthurGerbelot/rect-collide
----------------------------------------------------------------------------------------------------------------

type alias Line = {
    centerX : Float
    , centerY : Float
    , directionX : Float
    , directionY : Float
    }

create_2axis : (Float, Float) -> Float -> (Line, Line)
create_2axis (centerX, centerY) rot =
    let
        cosValue = cos rot
        sinValue = sin rot

        axisX = Line centerX centerY cosValue (negate (sinValue))
        axisY = Line centerX centerY sinValue cosValue
    in
    (axisX, axisY)

rectangle_corners : (Float, Float) -> (Float, Float) -> Float -> List (Float, Float)
rectangle_corners (centerX, centerY) (w, h) rot = 
    let
        cosW = (cos rot) * (w / 2)
        cosH = (cos rot) * (h / 2)
        sinW = (sin rot) * (w / 2)
        sinH = (sin rot) * (h / 2)

        -- TOP RIGHT corner
        corner1 = (centerX + cosW + sinH, centerY - sinW + cosH)
        -- BOTTOM RIGHT corner
        corner2 = (centerX + cosW - sinH, centerY - sinW - cosH)
        -- BOTTOM LEFT corner
        corner3 = (centerX - cosW - sinH, centerY + sinW - cosH)
        -- TOP LEFT corner
        corner4 = (centerX - cosW + sinH, centerY + sinW + cosH)
    in
    [corner1, corner2, corner3, corner4]

-- project_point => projects point onto a Line 
project_point : Line -> (Float, Float) -> (Float, Float) 
project_point axis (x, y) = 
    let
        dot = axis.directionX * (x - axis.centerX) + axis.directionY * (y - axis.centerY)

        newX = axis.centerX + axis.directionX * dot
        newY = axis.centerY + axis.directionY * dot
    in
    (newX, newY)

-- distance_from_center => returns distance of 2 points, but keeps the axis direction
-- used for calculating distance between point and center of a Line 
distance_from_center : Line -> (Float, Float) -> Float
distance_from_center axis (x, y) = 
    let
        (lenghtX, lenghtY) = (x - axis.centerX, y - axis.centerY)
        mult = 
            if (lenghtX * axis.directionX + lenghtY * axis.directionY > 0) then 1 
            else -1
    in
    sqrt (lenghtX * lenghtX + lenghtY * lenghtY) * mult

projection_colliding : Float -> List Float -> Bool
projection_colliding halfSize distances =
    let
        distMax =  Maybe.withDefault 0 (List.maximum distances)
        distMin =  Maybe.withDefault 0 (List.minimum distances)
    in
    (distMin < 0 && distMax > 0) || (abs(distMin) < halfSize) || (abs(distMax) < halfSize)

-- collision_2rectangles => returns TRUE if 2 rotated rectangles are colliding, otherwise FALSE
collision_2rectangles : (Float, Float) -> (Float, Float) -> Float -> (Float, Float) -> (Float, Float) -> Float -> Bool
collision_2rectangles (x1, y1) (w1, h1) rot1 (x2, y2) (w2, h2) rot2 =
    let
        -- create axis for rectangles
        (axis1X, axis1Y)  = create_2axis (x1, y1) rot1
        (axis2X, axis2Y)  = create_2axis (x2, y2) rot2

        -- calculate edges for rectangles
        corners1 = rectangle_corners (x1, y1) (w1, h1) rot1
        corners2 = rectangle_corners (x2, y2) (w2, h2) rot2

        hit1X = 
            -- corners of 1st rectangle projected onto X-axis of 2nd rectangle
            List.map (\o -> project_point axis2X o) corners1
            -- distances of projected points from center of 2nd rectangle (center of axisX)
            |> List.map (\o -> distance_from_center axis2X o) 
            |> projection_colliding (w2/2)

        hit1Y = 
            if hit1X then
                -- corners of 1st rectangle projected onto Y-axis of 2nd rectangle
                List.map (\o -> project_point axis2Y o) corners1
                -- distances of projected points from center of 2nd rectangle (center of axisY)
                |> List.map (\o -> distance_from_center axis2Y o)
                |> projection_colliding (h2/2) 
            else False

        hit2X = 
            if hit1Y then
                -- corners of 2st rectangle projected onto X-axis of 1nd rectangle
                List.map (\o -> project_point axis1X o) corners2
                -- distances of projected points from center of 1nd rectangle (center of axisX)
                |> List.map (\o -> distance_from_center axis1X o) 
                |> projection_colliding (w1/2) 
            else False

        hit2Y = 
            if hit2X then
                -- corners of 2st rectangle projected onto Y-axis of 1nd rectangle
                List.map (\o -> project_point axis1Y o) corners2
                -- distances of projected points from center of 1nd rectangle (center of axisY)
                |> List.map (\o -> distance_from_center axis1Y o)
                |> projection_colliding (h1/2) 
            else False

    in
    hit1X && hit1Y && hit2X && hit2Y


rotate_point : (Float, Float) -> (Float, Float) -> Float -> (Float, Float)
rotate_point (x, y) (centerX, centerY) rot = 
    let
        cosValue = cos rot
        sinValue = sin rot
        newX = centerX + cosValue * (x - centerX) + sinValue * (y - centerY)
        newY = centerY - sinValue * (x - centerX) + cosValue * (y - centerY)
    in
    (newX, newY)

-- collision_circle_rectangle => returns TRUE if circle and rotated rectangle are colliding, otherwise FALSE
collision_circle_rectangle : (Float, Float) -> Float -> (Float, Float) -> (Float, Float) -> Float -> Bool
collision_circle_rectangle (x1, y1) d (x2, y2) (w2, h2) rot2 =
    let
        halfW = w2 / 2
        halfH = h2 / 2
        
        -- rotating circle around the rectangle (rotate the center point of the circle)
        rotationDifference = negate (rot2)
        (cx, cy) = rotate_point (x1, y1) (x2, y2) rotationDifference

        nearX = max (x2 - halfW) <| min cx (x2 + halfW)
        nearY = max (y2 - halfH) <| min cy (y2 + halfH)

        distance = distance_of_2points (nearX, nearY) (cx, cy)
    in
    distance <= (d / 2)
