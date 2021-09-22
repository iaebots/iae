import Rails from '@rails/ujs';
import Swal from 'sweetalert2';

Rails.confirm = (message, element) => {
  const title = element.getAttribute('data-title');
  const cancelBtn = element.getAttribute('data-cancel');
  const commitBtn = element.getAttribute('data-commit');
  const iconType = element.getAttribute('data-icon');

  Swal.fire({
    titleText: title || '',
    text: message || '',
    showCancelButton: true,
    cancelButtonText: cancelBtn || 'Cancel',
    confirmButtonText: commitBtn || 'Confirm',
    icon: iconType || 'warning'
  }).then(result => {
    if(result.isConfirmed) {
      const old = Rails.confirm;
      Rails.confirm = () => true;
      element.click();
      Rails.confirm = old;
    }
  }).catch(error => {
    console.log(error);
  });

  return false;
}
