<?php

$host = "sp19-cs411-49.cs.illinois.edu"; // Host name.
$db_user = "root"; //mysql user
$db_password = "374sucks"; //mysql pass
$db = 'Stockopedia'; // Database name.
$conn = mysql_connect($host,$db_user,$db_password) or die (mysql_error());
mysql_select_db($db) or die (mysql_error());


echo $filename = "all_stocks_5yr.csv";
$ext = substr($filename, strrpos($filename, "."), (strlen($filename) - strrpos($filename, ".")));

//we check,file must be have csv extention
{
  $file = fopen($filename, "r");
         while (($emapData = fgetcsv($file, 10000, ",")) !== FALSE)
         {
            $sql = "INSERT into Stocks(date, open, high, low, close, volume, name) values('$emapData[0]', '$emapData[1]', '$emapData[2]', '$emapData[3]', '$emapData[4]', '$emapData[5]', '$emapData[6]')";
            mysql_query($sql);
         }
         fclose($file);
         echo "CSV File has been successfully Imported.";
}

?>
