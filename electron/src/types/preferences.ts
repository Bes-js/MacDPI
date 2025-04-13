export namespace Preferences {
    export type List = "showTitle" | "notifications" | "launchAtLogin";
    export type ListValue = boolean;
    export type ListType = {
        [key in List]: ListValue;
    };
};