# knitting html with default options

    Code
      cat(output)
    Output
      DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;
      ::: panel-tabset
      ## Listing
      <iframe width = '100%' class='resizable-iframe' srcdoc = '
      
      <style>table {margin-left: auto; margin-right: auto;}</style>
      '></iframe>
      ## Log
      <pre>
      
      56         ods listing close;ods html5 (id=saspy_internal) file=_tomods1 options(bitmap_mode='inline') device=svg style=HTMLBlue;
      56       ! ods graphics on / outputfmt=png;
      57         
      58         DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;
      59         
      60         
      61         ods html5 (id=saspy_internal) close;ods listing;
      62         
      
      63         
      </pre>
      :::

# knitting html with no evaluation does not evaluate the code

    Code
      cat(output)
    Output
      DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;

# knitting html with no echo shows no code

    Code
      cat(output)
    Output
      ::: panel-tabset
      ## Listing
      <iframe width = '100%' class='resizable-iframe' srcdoc = '
      lst output
      <style>table {margin-left: auto; margin-right: auto;}</style>
      '></iframe>
      ## Log
      <pre>
      log output
      </pre>
      :::

# knitting html with no output shows no results

    Code
      cat(output)
    Output
      DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;

# knitting html with capture log doesnt show lst

    Code
      cat(output)
    Output
      DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;
      <pre>
      log output
      </pre>

# knitting html with capture lst doesnt show log

    Code
      cat(output)
    Output
      DATA work.cars; set sashelp.cars; where EngineSize > 2; RUN;
      <iframe width = '100%' class='resizable-iframe' srcdoc = '
      lst output
      <style>table {margin-left: auto; margin-right: auto;}</style>
      '></iframe>

