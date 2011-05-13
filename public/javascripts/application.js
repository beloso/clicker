// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Invert all checkboxes at once by clicking a single checkbox.
function invertAll(headerfield, checkform, mask)
{
    for (var i = 0; i < checkform.length; i++)
    {
        if (typeof(checkform[i].name) == "undefined" || (typeof(mask) != "undefined" && checkform[i].name.substr(0, mask.length) != mask))
            continue;

        if (!checkform[i].disabled)
            checkform[i].checked = headerfield.checked;
    }
}
