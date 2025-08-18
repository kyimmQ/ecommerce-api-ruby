// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_tree .

// Application-wide JavaScript functions

// Form validation
document.addEventListener('DOMContentLoaded', function () {
    // Enable Bootstrap form validation
    const forms = document.querySelectorAll('.needs-validation');

    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });

    // Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        if (!alert.classList.contains('alert-permanent')) {
            setTimeout(() => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        }
    });
});

// Shopping cart functions
function addToCart(variantId, quantity = 1) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

    fetch('/buyer/cart/add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-Token': csrfToken
        },
        body: `product_variant_id=${variantId}&quantity=${quantity}`
    })
        .then(response => {
            if (response.ok) {
                window.location.reload();
            } else {
                alert('Failed to add item to cart');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Failed to add item to cart');
        });
}

// Quantity input controls
function updateQuantity(input, change) {
    const currentValue = parseInt(input.value);
    const newValue = currentValue + change;
    const min = parseInt(input.min) || 1;
    const max = parseInt(input.max) || 999;

    if (newValue >= min && newValue <= max) {
        input.value = newValue;
        input.dispatchEvent(new Event('change'));
    }
}
