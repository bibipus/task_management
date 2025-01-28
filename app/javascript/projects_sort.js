import Sortable from "https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/modular/sortable.esm.js";

document.addEventListener("turbo:load", () => {
    const projectList = document.querySelector("#sortable-projects");

    if (projectList) {
        new Sortable(projectList, {
            animation: 150,
            handle: ".drag-handle",
            onEnd: async (event) => {
                const order = Array.from(projectList.children).map((item) =>
                    item.dataset.id
                );

                await fetch("/projects/sort", {
                    method: "PATCH",
                    headers: {
                        "Content-Type": "application/json",
                        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
                    },
                    body: JSON.stringify({ order }),
                });
            },
        });
    }
});
