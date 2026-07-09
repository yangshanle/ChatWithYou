const THEME_KEY = 'chatwithyou-theme';
const THEME_PINK = 'pink';
const THEME_GREEN = 'green';

function saveTheme(theme) {
    try {
        localStorage.setItem(THEME_KEY, theme);
    } catch (e) {
        console.warn('无法保存主题到 localStorage:', e);
    }
}

function loadTheme() {
    try {
        return localStorage.getItem(THEME_KEY);
    } catch (e) {
        console.warn('无法读取主题:', e);
        return null;
    }
}

function applyTheme(theme) {
    const body = document.body;
    const toggleBtn = document.getElementById('themeToggle');
    
    if (theme === THEME_PINK) {
        body.classList.add('theme-pink');
        if (toggleBtn) {
            toggleBtn.textContent = '🌿';
        }
    } else {
        body.classList.remove('theme-pink');
        if (toggleBtn) {
            toggleBtn.textContent = '🎨';
        }
    }
}

function initTheme() {
    const savedTheme = loadTheme();
    if (savedTheme) {
        applyTheme(savedTheme);
    }
}

function toggleTheme() {
    const body = document.body;
    const isPink = body.classList.contains('theme-pink');
    const newTheme = isPink ? THEME_GREEN : THEME_PINK;
    
    applyTheme(newTheme);
    saveTheme(newTheme);
}

document.addEventListener('DOMContentLoaded', function() {
    initTheme();
    
    const toggleBtn = document.getElementById('themeToggle');
    if (toggleBtn) {
        toggleBtn.addEventListener('click', toggleTheme);
    }
});