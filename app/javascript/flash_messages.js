document.addEventListener('turbo:load', () => {
    const flashMessages = document.querySelectorAll('.flash-message');

    flashMessages.forEach((message) => {
        setTimeout(() => {
            message.style.transition = 'opacity 0.5s, transform 0.5s';
            message.style.opacity = '0';
            message.style.transform = 'translateY(10px)';
            setTimeout(() => message.remove(), 500);
        }, 5000);
    });

    document.querySelectorAll('.flash-message__close').forEach((closeButton) => {
        closeButton.addEventListener('click', (event) => {
            const message = event.target.closest('.flash-message');
            message.style.transition = 'opacity 0.5s, transform 0.5s';
            message.style.opacity = '0';
            message.style.transform = 'translateY(10px)';
            setTimeout(() => message.remove(), 500);
        });
    });
});
