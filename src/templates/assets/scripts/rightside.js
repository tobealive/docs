document.addEventListener('DOMContentLoaded', () => {
    setupRightSideWatcher()
});

function setupRightSideWatcher() {
    const setActive = (section) => {
        const link = document.querySelector('.aside-container li a[href="#' + section + '"]');
        if (link) {
            const parentLi = link.parentElement;
            parentLi.classList.add('active');
        }
    }

    const sectionPositions = [];
    const sections = document.querySelectorAll('h2');

    if (sections.length === 0) {
        return;
    }

    sections.forEach(section => {
        sectionPositions.push(section.offsetTop);
    });

    window.addEventListener('scroll', () => {
        document.querySelectorAll('.aside-container li[class="active"]').forEach(link => {
            link.classList.remove('active');
        });

        const scrollPosition = document.documentElement.scrollTop || document.body.scrollTop;

        const firstSectionPosition = sectionPositions[0] ?? 0;
        if (scrollPosition < firstSectionPosition) {
            setActive(sections[0].id);
            return
        }

        const lastSectionPosition = sectionPositions[sectionPositions.length - 1] ?? 0;
        if (scrollPosition > lastSectionPosition) {
            setActive(sections[sections.length - 1].id);
            return
        }

        for (let i = sectionPositions.length - 1; i >= 0; i--) {
            const section = sections[i];
            const position = sectionPositions[i];
            if (scrollPosition + 200 >= position) {
                setActive(section.id);
                break;
            }
        }
    });
}
