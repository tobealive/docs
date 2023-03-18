document.addEventListener('DOMContentLoaded', () => {
    const activeLink = document.querySelector(".link.active");
    if (activeLink !== null) {
        let parentItem = activeLink.closest('.js-item');
        // skip first item
        parentItem = parentItem.parentElement.closest('.js-item');
        for (let i = 0; i < 10; i++) {
            if (parentItem) {
                parentItem.classList.add('open');
                const list = parentItem.querySelector('.js-sub-list');
                if (list) {
                    list.classList.add('open');
                }
                parentItem = parentItem.parentElement.closest('.js-item');
            }

            if (!parentItem) {
                break;
            }
        }

        activeLink.scrollIntoView({block: "center", behavior: "auto"});
    }
})

document.querySelectorAll('.js-item .link').forEach((item) => {
    item.addEventListener('click', () => {
        const parent = item.parentElement;
        const innerList = parent.querySelector('.js-sub-list');
        if (innerList) {
            innerList.classList.toggle('open');
            parent.classList.toggle('open');
        }
    })
});

document.querySelectorAll('.js-sub-list').forEach((subList) => {
    subList.classList.remove('open')
});

const asideNavigation = document.querySelector("aside.navigation");
const closeAsideNavigationButton = asideNavigation.querySelector(".js-close-aside-navigation-button");
const asideNavigationOverlay = document.querySelector(".aside-navigation-overlay");
const openAsideNavigationButton = document.querySelector(".js-open-aside-navigation-button");

const closeAsideNavigation = () => {
    asideNavigation.classList.remove("open");
}

const openAsideNavigation = () => {
    asideNavigation.classList.add("open");
}

openAsideNavigationButton.addEventListener("click", () => {
    openAsideNavigation();
})

closeAsideNavigationButton.addEventListener("click", () => {
    closeAsideNavigation();
});

asideNavigationOverlay.addEventListener("click", () => {
    closeAsideNavigation();
});
