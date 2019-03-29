<?php
    // Create connection
    $con=mysqli_connect("sp19-cs411-49.cs.illinois.edu", "root", "374sucks", "Stockopedia");

    // Check connection
    if (mysqli_connect_errno()){
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    
    if($_GET["query"] === "get_all_stock_names"){
        get_all_stock_names();
        echo "ALL STOCKS";
    }else if($_GET["query"] === "test"){
        test();
        echo "TEST";
    }
    else{
        echo "ERROR";
        echo $_GET["query"];
    }

    function get_all_stock_names() {
        echo "HERE";
        
        
        // This SQL statement selects ALL from the table 'hstocks'
        $sql = "SELECT name
        FROM hstocks
        GROUP BY name";
        
        // Check if there are results
        if ($result = mysqli_query($con, $sql)){
            // If so, then create a results array and a temporary one
            // to hold the data
            $resultArray = array();
            $tempArray = array();
            
            // Loop through each row in the result set
            while($row = $result->fetch_object()){
                // Add each row into our results array
                $tempArray = $row;
                array_push($resultArray, $tempArray);
            }
            
            // Finally, encode the array to JSON and output the results
            echo json_encode($resultArray);
        }
    }
    
    function test() {
        // This SQL statement selects ALL from the table 'hstocks'
        $sql = "SELECT name
        FROM hstocks
        WHERE name = 'AAPL'";
        
        // Check if there are results
        if ($result = mysqli_query($con, $sql)){
            // If so, then create a results array and a temporary one
            // to hold the data
            $resultArray = array();
            $tempArray = array();
            
            // Loop through each row in the result set
            while($row = $result->fetch_object()){
                // Add each row into our results array
                $tempArray = $row;
                array_push($resultArray, $tempArray);
            }
            
            // Finally, encode the array to JSON and output the results
            echo json_encode($resultArray);
        }
        
        echo "YO";
    }
 
    echo "YO2";
    // Close connections
    mysqli_close($con);
?>
