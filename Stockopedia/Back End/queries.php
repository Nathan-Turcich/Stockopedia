<?php
    $con=mysqli_connect("sp19-cs411-49.cs.illinois.edu","root","374sucks","Stockopedia");   // Create connection

    if (mysqli_connect_errno()) { echo "Failed to connect to MySQL: " . mysqli_connect_error(); }
    
    //All Queries
    
    $sql = "";
    if($_GET["query"] === "test") {
        $sql = "SELECT name
        FROM hstocks
        WHERE name = 'AAPL'";
    }else if($_GET["query"] === "get_all_stock_names"){
        $sql = "SELECT name
        FROM hstocks
        GROUP BY name";
    }else if($_GET["query"] === "create_user"){
        $key = $_GET["key"];
        $username = $_GET["username"];
        $password = $_GET["password"];
        
        $sql = "INSERT INTO Users
        VALUES ('$key', '$username', '$password')";
    }else if($_GET["query"] === "get_user"){
        $key = $_GET["key"];
        
        $sql = "SELECT ID, Username
        FROM Users
        WHERE key = '$key'";
    }
    
    //Result of queries
    if ($result = mysqli_query($con, $sql)) {     // Check if there are results
        // If so, then create a results array and a temporary one to hold the data
        $resultArray = array();
        $tempArray = array();
        
        while($row = $result->fetch_object()) {     // Loop through each row in the result set
            $tempArray = $row;
            array_push($resultArray, $tempArray);   // Add each row into our results array
        }
        
        echo json_encode($resultArray);     // Encode the array to JSON and output the results
    }
    
    mysqli_close($con); // Close connections
?>
