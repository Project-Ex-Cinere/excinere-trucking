window.addEventListener('message', (event) => {
    if (event.data.action === "showUI") {
        document.querySelector('.container').style.display = 'block';
    }
});

function startQuickJob() {
    fetch(`https://${GetParentResourceName()}/startQuickJob`, {
        method: 'POST'
    });
    closeUI();
}

function startFreightJob() {
    fetch(`https://${GetParentResourceName()}/startFreightJob`, {
        method: 'POST'
    });
    closeUI();
}

function closeUI() {
    document.querySelector('.container').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeUI`, {
        method: 'POST'
    });
}
