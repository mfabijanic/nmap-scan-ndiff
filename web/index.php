<?php
  // Force PHP to use the UTF-8 charset
  header('Content-type: text/html; charset=utf-8');
  session_start();

  include 'config.php';

  if (!empty($_SERVER['REMOTE_USER'])) {
    $_SESSION['username'] = $_SERVER['REMOTE_USER'];
    $username = $_SESSION['username'];
    $user = explode('@', $username)[0];
    $samaccountname = $user;
  }

  if(empty($_SESSION['xmlFile'])) {
    $xmlFile = '';
  } else {
    $xmlFile = $_SESSION['xmlFile'];
  }

  if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if(empty($_REQUEST['xmlFile'])) {
      $xmlFile = 'ndiff-nmap-scan.xml';
    } else {
      $xmlFile = $_REQUEST['xmlFile'];
      $_SESSION['xmlFile'] = $xmlFile;
    }
  }
  $xslFile = 'ndiff-nmap-scan.xsl';
  $xmlFilePath = "$dir/$xmlFile";
?>
<!DOCTYPE html>
<html>
<head>
  <title>Nmap Diff Result</title>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="description" content="">
  <meta name="author" content="Matej Fabijanić">
      
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous" />

  <script src="ndiff-nmap-scan.js"></script>
</head>

<?php
  #if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if(empty($xmlFile)) {
    echo '<body>';
  } else {
    echo '<body onload="displayResult(\'' . $xmlFilePath . '\', \'' . $xslFile . '\')">';
  }

  // Ndiff XML files
  $fileList = glob($dir . '/ndiff-*.xml');

  foreach($fileList as $filename) {
    // Use the is_file function to make sure that it is not a directory.
    if(is_file($filename)) {
      // put in array, filename without path
      $files[] = substr($filename, strrpos($filename,"/") + 1);
    }
  }
?>

  <div class="container">

    <nav class="navbar navbar-light bg-light">
      <div class="container">
        <div class="float-start"></div>
        <div class="float-end">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
            <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
            <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
          </svg>
          <?php echo $username; ?><br><br>
        </div>
      </div>
      <div class="container-fluid">
        <a class="navbar-brand">Nmap Diff</a>
        <form class="needs-validation" novalidate method="POST" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
          <div class="row g-3">
            <div class="col-auto">
              <select id="xmlFile" name="xmlFile" class="form-select" aria-label=".form-select-md" required>
                <option></option>
                <?php
                  rsort($files);
                  foreach($files as $file) {
                    $without_extension = basename($file, '.xml');
                    $date_from_filename = ltrim($without_extension, 'ndiff-');
                    $file_description = $date_from_filename;
                    if($file_description == "prev") {
                      //$file_description = "Latest";
                      continue;
                    }
                    // remove "_" from date
                    $file_description = str_replace("_", " ", $file_description);
                    if ($file == $xmlFile) {
                      echo "<option value=\"" . $file . "\" selected>" . $file_description . "</option>";
                    }
                    else {
                      echo "<option value=\"" . $file . "\">" . $file_description . "</option>";
                    }
                  }
                ?>
              </select>
            </div>
            <div class="col-auto">
              <input type="hidden" id="send" name="send" value="1">
              <button class="w-100 btn btn-primary btn-md" type="submit">Submit</button>
            </div>
          </div>
        </form>
      </div>
    </nav>
    <br />

    <div id="ndiffResult" />
  </div>

    <!-- Optional JavaScript; choose one of the two! -->

    <!-- Option 1: Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

    <!-- Option 2: Separate Popper and Bootstrap JS -->
    <!--
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js" integrity="sha384-7+zCNj/IqJ95wo16oMtfsKbZ9ccEh31eOz1HGyDuCQ6wgnyJNSYdrPa03rtR1zdB" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
    -->
</body>
</html>

