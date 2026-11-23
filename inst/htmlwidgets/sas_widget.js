HTMLWidgets.widget({

  name: 'sas_widget',

  type: 'output',

  factory: function (el, width, height) {
    let observer = null;

    return {

      renderValue: function (x) {
        if (observer) {
          observer.disconnect();
          observer = null;
        }

        let lst = x.lst;
        let log = x.log;
        let capture = x.capture;

        let id_prefix = el.id;

        if (capture == "both") {
          el.innerHTML = `
            <style>
            body {
              overflow: auto !important;
            }
            /* Force non-active tabs to hide even if the template uses flexbox */
            #${id_prefix}-myTabContent .tab-pane:not(.active) {
              display: none !important;
            }
            </style>
            <ul class="nav nav-tabs" id="${id_prefix}-myTab" role="tablist">
              <li class="nav-item" role="presentation">
                <button class="nav-link active" id="${id_prefix}-lst-tab" data-bs-toggle="tab" data-bs-target="#${id_prefix}-lst" type="button" role="tab" aria-controls="${id_prefix}-lst" aria-selected="true">Listing</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="${id_prefix}-log-tab" data-bs-toggle="tab" data-bs-target="#${id_prefix}-log" type="button" role="tab" aria-controls="${id_prefix}-log" aria-selected="false">Log</button>
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

        const iframe = el.querySelector('.resizable-iframe');
        if (iframe && typeof adjustIframeHeight === 'function') {
          iframe.addEventListener('load', () => adjustIframeHeight(iframe));

          if (iframe.contentDocument && iframe.contentDocument.readyState === 'complete') {
            adjustIframeHeight(iframe);
          }

          let lastWidth = 0;
          observer = new ResizeObserver(() => {
            const currentWidth = iframe.clientWidth;
            if (currentWidth === 0) {
              lastWidth = 0;
              return;
            }
            if (currentWidth !== lastWidth) {
              lastWidth = currentWidth;
              adjustIframeHeight(iframe);
            }
          });
          observer.observe(iframe);
        }
      },

      resize: function (width, height) {
        const iframe = el.querySelector('.resizable-iframe');
        if (iframe && typeof adjustIframeHeight === 'function') {
          adjustIframeHeight(iframe);
        }
      }

    };
  }
});