<html>
    <body>
        <?php 
            echo "<div style='display: none;'>";
            foreach ($_POST as $key => $value) {
                echo "<p>$key:$value</p>";
            }
            echo "</div>";
        ?>  
    </body>
</html>