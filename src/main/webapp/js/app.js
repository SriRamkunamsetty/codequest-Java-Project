/**
 * CodeQuest Interactive Micro-animations & UI Engine
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Interactive Option Card Selection for Missions
    initOptionCardSelection();

    // 2. Client-side Category & Difficulty Filters
    initMissionFilters();

    // 3. Victory Confetti Celebration
    initVictoryConfetti();

    // 4. Auto-dismiss Alert Banners
    initAutoDismissAlerts();
});

/**
 * Enables smooth radio selection by clicking anywhere on an option card.
 */
function initOptionCardSelection() {
    const cards = document.querySelectorAll('.option-card');
    cards.forEach(card => {
        card.addEventListener('click', function () {
            const radio = this.querySelector('input[type="radio"]');
            if (radio && !radio.disabled) {
                radio.checked = true;
                
                // Clear selection from all peer options in the same group/form
                const form = this.closest('form');
                if (form) {
                    form.querySelectorAll('.option-card').forEach(c => c.classList.remove('selected'));
                } else {
                    cards.forEach(c => c.classList.remove('selected'));
                }

                this.classList.add('selected');
            }
        });
    });
}

/**
 * Client-side mission filtering for ultra-fast instant UI responsiveness.
 */
function initMissionFilters() {
    const categoryBtns = document.querySelectorAll('[data-filter-cat]');
    const difficultyBtns = document.querySelectorAll('[data-filter-diff]');
    const missionCards = document.querySelectorAll('.mission-item');

    if (!categoryBtns.length && !missionCards.length) return;

    let activeCategory = 'ALL';
    let activeDifficulty = 'ALL';

    function applyFilters() {
        missionCards.forEach(card => {
            const cardCat = card.getAttribute('data-category') || '';
            const cardDiff = card.getAttribute('data-difficulty') || '';

            const catMatch = (activeCategory === 'ALL' || cardCat.toUpperCase() === activeCategory.toUpperCase());
            const diffMatch = (activeDifficulty === 'ALL' || cardDiff.toUpperCase() === activeDifficulty.toUpperCase());

            if (catMatch && diffMatch) {
                card.style.display = 'block';
                card.style.animation = 'fadeIn 0.25s ease-out forwards';
            } else {
                card.style.display = 'none';
            }
        });
    }

    categoryBtns.forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            categoryBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            activeCategory = this.getAttribute('data-filter-cat');
            applyFilters();
        });
    });

    difficultyBtns.forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            difficultyBtns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            activeDifficulty = this.getAttribute('data-filter-diff');
            applyFilters();
        });
    });
}

/**
 * Auto-fades alerts after 5 seconds.
 */
function initAutoDismissAlerts() {
    const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });
}

/**
 * Lightweight, high-performance canvas confetti celebration effect.
 */
function initVictoryConfetti() {
    const canvas = document.getElementById('confettiCanvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    const colors = ['#6366f1', '#4f46e5', '#f59e0b', '#10b981', '#38bdf8', '#fb923c'];
    const particles = [];
    const particleCount = 120;

    for (let i = 0; i < particleCount; i++) {
        particles.push({
            x: canvas.width / 2,
            y: canvas.height / 2 + 50,
            r: Math.random() * 6 + 3,
            d: Math.random() * particleCount,
            color: colors[Math.floor(Math.random() * colors.length)],
            tilt: Math.floor(Math.random() * 10) - 10,
            tiltAngleIncremental: (Math.random() * 0.07) + 0.05,
            tiltAngle: 0,
            vx: (Math.random() - 0.5) * 18,
            vy: (Math.random() * -18) - 4,
            gravity: 0.35,
            opacity: 1
        });
    }

    let animationFrameId;
    let frames = 0;

    function render() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        frames++;

        let activeParticles = 0;

        for (let i = 0; i < particles.length; i++) {
            const p = particles[i];
            p.x += p.vx;
            p.y += p.vy;
            p.vy += p.gravity;
            p.vx *= 0.98;
            p.tiltAngle += p.tiltAngleIncremental;
            p.tilt = Math.sin(p.tiltAngle - (i / 3)) * 15;

            if (frames > 40) {
                p.opacity -= 0.012;
            }

            if (p.opacity > 0 && p.y < canvas.height + 20) {
                activeParticles++;
                ctx.beginPath();
                ctx.lineWidth = p.r / 2;
                ctx.strokeStyle = p.color;
                ctx.globalAlpha = Math.max(0, p.opacity);
                ctx.moveTo(p.x + p.tilt + (p.r / 4), p.y);
                ctx.lineTo(p.x + p.tilt, p.y + p.tilt + (p.r / 4));
                ctx.stroke();
                ctx.globalAlpha = 1;
            }
        }

        if (activeParticles > 0) {
            animationFrameId = requestAnimationFrame(render);
        } else {
            cancelAnimationFrame(animationFrameId);
            canvas.remove();
        }
    }

    render();
}
