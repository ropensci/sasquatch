function adjustIframeHeight(iframe) {
    const iframeDocument = iframe.contentDocument || iframe.contentWindow.document;    
    iframe.style.height = iframeDocument.documentElement.scrollHeight + 'px';
}

function adjustAllIframes() {
    const iframes = document.querySelectorAll('.resizable-iframe'); 
    
    iframes.forEach((iframe) => {
        adjustIframeHeight(iframe); 
    });
}

document.querySelectorAll('.resizable-iframe').forEach((iframe) => {
    iframe.onload = function() {
        adjustIframeHeight(iframe);
    };
});

window.addEventListener('resize', adjustAllIframes);
window.onload = adjustAllIframes;
