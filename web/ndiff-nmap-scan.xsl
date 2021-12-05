<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html lang="en">
    <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      
      <!-- Bootstrap CSS -->
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous" />
    </head>

    <body>
      <div class="container">


          <h1>Scan Diff</h1>

          <table class="table table-hover table-bordered table-striped shadow">
            <thead>
              <tr>
                <th scope="col"></th>
                <!-- <th scope="col">Scanner</th> -->
                <th scope="col">Command/Arguments</th>
                <!-- <th scope="col">Start</th> -->
                <th scope="col">Start</th>
              </tr>
            </thead>
            <tbody>
            <tr>
              <td><span class="badge bg-secondary">-</span></td>
              <!-- <td><xsl:value-of select="/nmapdiff/scandiff/a/nmaprun/@scanner" /></td> -->
              <td>
                <p class="font-monospace">
                  <xsl:value-of select="/nmapdiff/scandiff/a/nmaprun/@args" />
                </p>
              </td>
              <!-- <td><xsl:value-of select="/nmapdiff/scandiff/a/nmaprun/@start" /></td> -->
              <td><xsl:value-of select="/nmapdiff/scandiff/a/nmaprun/@startstr" /></td>
            </tr>
            <tr>
              <td><span class="badge bg-secondary">+</span></td>
              <!-- <td><xsl:value-of select="/nmapdiff/scandiff/b/nmaprun/@scanner" /></td> -->
              <td>
                <p class="font-monospace">
                  <xsl:value-of select="/nmapdiff/scandiff/b/nmaprun/@args" />
                </p>
              </td>
              <!-- <td><xsl:value-of select="/nmapdiff/scandiff/b/nmaprun/@start" /></td> -->
              <td><xsl:value-of select="/nmapdiff/scandiff/b/nmaprun/@startstr" /></td>
            </tr>
            </tbody>
          </table>
          <br />
          

          <h1>Host Diff</h1>

          <table class="table table-hover table-bordered table-striped shadow">
            <thead>
              <tr>
                <th scope="col">Status</th>
                <th scope="col">Address</th>
                <!-- <th scope="col">Address Type</th> -->
                <th scope="col">Hostnames</th>
                <th scope="col">Ports</th>
              </tr>
            </thead>
            <tbody>

            <xsl:for-each select="nmapdiff/scandiff/hostdiff">
              <tr>

                <td>
                  <xsl:attribute name="status">
                    <xsl:value-of select="b/host/status/@state" />
                  </xsl:attribute>
                  <xsl:value-of select="b/host/status/@state" />
                </td>
                <td><xsl:value-of select="b/host/address/@addr" /></td>
                <!-- <td><xsl:value-of select="b/host/address/@addrtype" /></td> -->

                <td>
                  <!-- Host: /nmapdiff/scandiff/hostdiff/b/host/hostnames -->
                  <!-- <table class="table table-hover table-bordered table-striped shadow">
                    <tr>
                    -->
                    <ul class="list-group">
                      <xsl:for-each select="b/host/hostnames">
                        <!-- <td> -->
                          <li class="list-group-item"><xsl:value-of select="hostname/@name" /></li>
                        <!-- </td> -->
                      </xsl:for-each>
                    </ul>
                    <!-- </tr>
                  </table>
                -->
                </td>

                <td>
                  <!-- Ports -->
                  <xsl:for-each select="b/host/ports">

                    <!-- Ports - Extraports -->
                    <table class="table table-hover table-bordered table-striped shadow">
                      <thead>
                        <tr>
                          <th><span class="badge bg-secondary">Extraports</span></th>
                          <th>State</th>
                          <th>Count</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td></td>
                          <td><xsl:value-of select="extraports/@state" /></td>
                          <td><xsl:value-of select="extraports/@count" /></td>
                        </tr>
                      </tbody>
                    </table>
                    <!-- /Ports - Extraports -->

                    <!-- Ports - Table 2 -->
                    <table class="table table-hover table-bordered table-striped shadow">
                      <thead>
                        <tr>
                          <th>Port</th>
                          <th>Protocol</th>
                          <th>State</th>
                          <th>Name</th>
                          <th>Version</th>
                          <th>Extrainfo</th>
                        </tr>
                      </thead>
                      <tbody>

                      <xsl:for-each select="port">
                        <tr>
                          <td><xsl:value-of select="@portid" /></td>
                          <td><xsl:value-of select="@protocol" /></td>
                          <td><xsl:value-of select="state/@state" /></td>
                          <td><xsl:value-of select="service/@name" /></td>
                          <td><xsl:value-of select="service/@version" /></td>
                          <td><xsl:value-of select="service/@extrainfo" /></td>
                        </tr> 
                      </xsl:for-each>
                      
                      </tbody>
                    </table>
                    <!-- /Ports - Table 2 -->

                  </xsl:for-each>
                  <!-- /Ports -->

                </td>
              </tr>
            
            </xsl:for-each>
            </tbody>
          </table>

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

</xsl:template>

</xsl:stylesheet>
