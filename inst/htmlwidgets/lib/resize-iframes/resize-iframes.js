function adjustIframeHeight(iframe) {
    if (iframe.offsetParent === null) return;

    const iframeWin = iframe.contentWindow;
    const iframeDocument = iframe.contentDocument || iframeWin?.document;
    if (!iframeDocument || !iframeDocument.documentElement) return;

    const docEl = iframeDocument.documentElement;
    const body = iframeDocument.body;

    iframe.style.height = '0px';

    const contentHeight = Math.ceil(Math.max(
        docEl.scrollHeight,
        body ? body.scrollHeight : 0,
        docEl.getBoundingClientRect().height,
        body ? body.getBoundingClientRect().height : 0
    ));

    if (contentHeight === 0) return;

    const chromeHeight = iframe.offsetHeight - iframe.clientHeight;

    iframe.style.height = (contentHeight + chromeHeight) + 'px';

    const hScrollbarHeight = iframeWin.innerHeight - docEl.clientHeight;
    if (hScrollbarHeight > 0) {
        iframe.style.height = (contentHeight + chromeHeight + hScrollbarHeight) + 'px';
    }
}

function adjustAllIframes() {
    document.querySelectorAll('.resizable-iframe').forEach((iframe) => {
        adjustIframeHeight(iframe);
    });
}

// Re-adjust on window resize
window.addEventListener('resize', adjustAllIframes);
window.addEventListener('load', adjustAllIframes);
