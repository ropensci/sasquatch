HTMLWidgets.widget({

  name: 'sas_widget',

  type: 'output',

  factory: function (el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function (x) {
        let lst = x.lst;
        let log = x.log;


        el.innerHTML = `
<style>body {overflow: auto !important;}</style>
<ul class="nav nav-tabs" id="myTab" role="tablist">
  <li class="nav-item" role="presentation">
    <button class="nav-link active" id="lst-tab" data-bs-toggle="tab" data-bs-target="#lst" type="button" role="tab" aria-controls="lst" aria-selected="true">Listing</button>
  </li>
  <li class="nav-item" role="presentation">
    <button class="nav-link" id="log-tab" data-bs-toggle="tab" data-bs-target="#log" type="button" role="tab" aria-controls="log" aria-selected="false">Log</button>
  </li>
</ul>
<div style = "height: calc(100% - 49px) !important" class="tab-content" id="myTabContent">
  <div style = "height: 100% !important" class="tab-pane fade show active" id="lst" role="tabpanel" aria-labelledby="lst-tab">
    <iframe width = '100%' class='resizable-iframe' srcdoc = '${lst}<style>table {margin-left: auto; margin-right: auto;}</style>'></iframe>
  </div>
  <div style = "height: 100% !important" class="tab-pane fade" id="log" role="tabpanel" aria-labelledby="log-tab"><pre>${log}</pre></div>
</div>`;

      },

      resize: function (width, height) {

      }

    };
  }
});