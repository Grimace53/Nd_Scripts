let plantData = {
    health: 100,
    light: 75,
    water: 50,
    fertilizer: 0
};

// Listen for messages from Lua
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.type === 'toggle') {
        const container = document.getElementById('plant-container');
        if (data.show) {
            container.classList.remove('hidden');
            if (data.data) {
                plantData = data.data;
                updateUI();
            }
        } else {
            container.classList.add('hidden');
        }
    } else if (data.type === 'update') {
        if (data.data) {
            plantData = data.data;
            updateUI();
        }
    }
});

// Update UI with current plant data
function updateUI() {
    // Update health
    document.getElementById('health-value').textContent = plantData.health + '%';
    document.getElementById('health-bar').style.width = plantData.health + '%';
    
    // Update light
    document.getElementById('light-value').textContent = Math.round(plantData.light) + '%';
    document.getElementById('light-bar').style.width = plantData.light + '%';
    document.getElementById('light-slider').value = plantData.light;
    
    // Update water
    document.getElementById('water-value').textContent = Math.round(plantData.water) + '%';
    document.getElementById('water-bar').style.width = plantData.water + '%';
    document.getElementById('water-slider').value = plantData.water;
    
    // Update fertilizer
    document.getElementById('fertilizer-value').textContent = Math.round(plantData.fertilizer) + '%';
    document.getElementById('fertilizer-bar').style.width = plantData.fertilizer + '%';
    document.getElementById('fertilizer-slider').value = plantData.fertilizer;
    
    // Update plant visual based on health
    const plant = document.getElementById('plant-visual');
    if (plantData.health > 70) {
        plant.textContent = '🌿';
        plant.className = 'plant healthy';
    } else if (plantData.health > 40) {
        plant.textContent = '🌱';
        plant.className = 'plant';
    } else if (plantData.health > 10) {
        plant.textContent = '🥀';
        plant.className = 'plant wilting';
    } else {
        plant.textContent = '🪴';
        plant.className = 'plant wilting';
    }
}

// Close NUI
function closeNUI() {
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

// Get parent resource name (FiveM specific)
function GetParentResourceName() {
    let currentUrl = window.location.href;
    let query = currentUrl.split('?')[1];
    if (query) {
        return query.replace('/', '');
    }
    return 'nui-frame-app';
}

// Handle ESC key to close NUI
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeNUI();
    }
});

// Slider event listeners
document.getElementById('light-slider').addEventListener('input', function(e) {
    const value = parseInt(e.target.value);
    plantData.light = value;
    updateLevels();
});

document.getElementById('water-slider').addEventListener('input', function(e) {
    const value = parseInt(e.target.value);
    plantData.water = value;
    updateLevels();
});

document.getElementById('fertilizer-slider').addEventListener('input', function(e) {
    const value = parseInt(e.target.value);
    plantData.fertilizer = value;
    updateLevels();
});

// Update levels on server
function updateLevels() {
    fetch(`https://${GetParentResourceName()}/updateLevels`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            light: plantData.light,
            water: plantData.water,
            fertilizer: plantData.fertilizer
        })
    })
    .then(response => response.json())
    .then(data => {
        plantData = data;
        updateUI();
    });
}

// Initialize UI
updateUI();
