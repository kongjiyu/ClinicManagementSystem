// Malaysian Date Formatting Utilities
// This file provides utility functions for formatting dates in Malaysian format (dd/mm/yyyy)

/**
 * Format a date to Malaysian format (dd/mm/yyyy)
 * @param {Date|string} date - The date to format
 * @returns {string} Formatted date in dd/mm/yyyy format or 'N/A' if invalid
 */
function formatMalaysianDate(date) {
  if (!date) return 'N/A';
  
  const d = new Date(date);
  if (isNaN(d.getTime())) return 'N/A';
  
  const day = String(d.getDate()).padStart(2, '0');
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const year = d.getFullYear();
  
  return `${day}/${month}/${year}`;
}

/**
 * Format a date and time to Malaysian format (dd/mm/yyyy HH:mm)
 * @param {Date|string} date - The date to format
 * @returns {string} Formatted date and time in dd/mm/yyyy HH:mm format or 'N/A' if invalid
 */
function formatMalaysianDateTime(date) {
  if (!date) return 'N/A';
  
  const d = new Date(date);
  if (isNaN(d.getTime())) return 'N/A';
  
  const day = String(d.getDate()).padStart(2, '0');
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const year = d.getFullYear();
  const hours = String(d.getHours()).padStart(2, '0');
  const minutes = String(d.getMinutes()).padStart(2, '0');
  
  return `${day}/${month}/${year} ${hours}:${minutes}`;
}

/**
 * Format time to Malaysian format (HH:mm)
 * @param {Date|string} date - The date to format
 * @returns {string} Formatted time in HH:mm format or 'N/A' if invalid
 */
function formatMalaysianTime(date) {
  if (!date) return 'N/A';
  
  const d = new Date(date);
  if (isNaN(d.getTime())) return 'N/A';
  
  const hours = String(d.getHours()).padStart(2, '0');
  const minutes = String(d.getMinutes()).padStart(2, '0');
  
  return `${hours}:${minutes}`;
}

/**
 * Override the default toLocaleDateString method to use Malaysian format
 * This function can be used to replace existing toLocaleDateString calls
 * @param {Date} date - The date object
 * @returns {string} Formatted date in dd/mm/yyyy format
 */
function toMalaysianDateString(date) {
  return formatMalaysianDate(date);
}

// Make functions available globally
window.formatMalaysianDate = formatMalaysianDate;
window.formatMalaysianDateTime = formatMalaysianDateTime;
window.formatMalaysianTime = formatMalaysianTime;
window.toMalaysianDateString = toMalaysianDateString;
