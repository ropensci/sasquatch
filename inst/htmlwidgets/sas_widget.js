HTMLWidgets.widget({

  name: 'sas_widget',

  type: 'output',

  factory: function (el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function (x) {
        let lst = x.lst;
        let log = x.log;
        let capture = x.capture;

        let id_prefix = el.id;

        if (capture == "both") {
          el.innerHTML = `
            <style>body {overflow: auto !important;}</style>
            <ul class="nav nav-tabs" id="${id_prefix}-myTab" role="tablist">
              <li class="nav-item" role="presentation">
                <button class="nav-link active" id="${id_prefix}-lst-tab" data-bs-toggle="tab" data-bs-target="#${id_prefix}-lst" type="button" role="tab" aria-controls="${id_prefix}-lst" aria-selected="true">Listing</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="${id_prefix}-log-tab" data-bs-toggle="tab" data-bs-target="${id_prefix}-log" type="button" role="tab" aria-controls="${id_prefix}-log" aria-selected="false">Log</button>
              </li>
            </ul>
            <div style = "display: inline-block; width: 100%" class="tab-content" id="${id_prefix}-myTabContent">
              <div style = "height: 100% !important" class="tab-pane fade show active" id="${id_prefix}-lst" role="tabpanel" aria-labelledby="${id_prefix}-lst-tab">
                <iframe width = '100%' class='resizable-iframe' srcdoc = '${lst}<style>table {margin-left: auto; margin-right: auto;}</style>'></iframe>
              </div>
              <div style = "height: 100% !important" class="tab-pane fade" id="${id_prefix}-log" role="tabpanel" aria-labelledby="${id_prefix}-log-tab"><pre>${log}</pre></div>
            </div>
          `;
        } else if (capture == "listing") {
          el.innerHTML = `
            <iframe width = '100%' class='resizable-iframe' srcdoc = '${lst}<style>table {margin-left: auto; margin-right: auto;}</style>'></iframe>
          `;
        } else if (capture == "log") {
          el.innerHTML = `
            <pre>${log}</pre>
          `;
        }

      },

      resize: function (width, height) {

      }

    };
  }
});