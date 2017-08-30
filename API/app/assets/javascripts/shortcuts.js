/**
 * User: Mohamed Eid
 * Date: 3/22/13
 * Time: 4:27 AM
 */

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}