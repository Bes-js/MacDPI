import React, { useState, useRef, useEffect } from "react";
import "../../app/globals.css";
import { FaMinus, FaPlus } from "react-icons/fa6";

interface TableItem {
    id: number;
    domain: string;
}

/* Language Type */
import type { LanguageType } from "@/utils/language";

const Pattern = ({ language }: { language: LanguageType }) => {
    const [items, setItems] = useState<TableItem[]>([]);
    const [selectedId, setSelectedId] = useState<number | null>(null);
    const [editingId, setEditingId] = useState<number | null>(null);
    const [editingValue, setEditingValue] = useState<string>("");
    const [isAdding, setIsAdding] = useState<boolean>(false);
    const [newItemId, setNewItemId] = useState<number | null>(null);

    const editInputRef = useRef<HTMLInputElement>(null);
    const containerRef = useRef<HTMLDivElement>(null);
    const tableBodyRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (editingId !== null && editInputRef.current) {
            editInputRef.current.focus({ preventScroll: true });
        }
    }, [editingId]);

    useEffect(() => {
        if (isAdding && tableBodyRef.current) {
            tableBodyRef.current.scrollTop = tableBodyRef.current.scrollHeight;
        }
    }, [isAdding, items.length]);

    useEffect(() => {
        function handleClickOutside(event: MouseEvent) {
            if (isAdding && containerRef.current && !containerRef.current.contains(event.target as Node)) {
                cancelAddItem();
            }
        }

        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, [isAdding]);

    useEffect(() => {
        window?.electron.ipcRenderer.on("getPattern", (_, data: TableItem[]) => {
            setItems(data);
        });

        window?.electron.ipcRenderer.send("getPattern");

        return () => {
            window?.electron.ipcRenderer.removeAllListeners("getPattern");
        };
    }, []);

    const addItem = (): void => {
        const newId = items.length > 0 ? Math.max(...items.map(item => item.id)) + 1 : 1;
        const newItem: TableItem = {
            id: newId,
            domain: ``,
        };

        setItems([...items, newItem]);
        setSelectedId(newId);
        setNewItemId(newId);
        setIsAdding(true);
        setEditingId(newId);
        setEditingValue("");
    };

    const cancelAddItem = (): void => {
        if (newItemId !== null) {
            const updatedItems = items.filter(item => item.id !== newItemId);
            setItems(updatedItems);
            window?.electron.ipcRenderer.send("setPattern", updatedItems);
        }
        setIsAdding(false);
        setNewItemId(null);
        setEditingId(null);
    };

    const removeItem = (): void => {
        if (selectedId !== null) {
            const updatedItems = items.filter(item => item.id !== selectedId);
            setItems(updatedItems);
            setSelectedId(null);
            window?.electron.ipcRenderer.send("setPattern", updatedItems);
        }
    };

    const handleItemClick = (id: number): void => {
        if (!isAdding) {
            setSelectedId(id);
        }
    };

    const handleDoubleClick = (item: TableItem): void => {
        if (!isAdding) {
            setEditingId(item.id);
            setEditingValue(item.domain);
        }
    };

    const handleEditChange = (e: React.ChangeEvent<HTMLInputElement>): void => {
        setEditingValue(e.target.value);
    };

    const handleEditKeyDown = (e: React.KeyboardEvent<HTMLInputElement>): void => {
        if (e.key === "Enter") {
            if (editingValue.trim() === "") {
                cancelEdit();
                return;
            }
            if (isAdding) {
                saveNewItem();
            } else {
                saveEdit();
            }
        } else if (e.key === "Escape") {
            cancelEdit();
        }
    };

    const saveNewItem = (): void => {
        if (editingId === null) return;

        if (editingValue === "" || !hasDomain(editingValue)) {
            const updatedItems = items.filter(item => item.id !== editingId);
            setItems(updatedItems);
            window?.electron.ipcRenderer.send("setPattern", updatedItems);
        } else {
            const updatedItems = items.map(item =>
                item.id === editingId
                    ? {
                          ...item,
                          domain: editingValue.replace(/(^\w+:|^)\/\//, "")
                      }
                    : item
            );
            setItems(updatedItems);
            window?.electron.ipcRenderer.send("setPattern", updatedItems);
        }

        resetEditStates();
    };

    const saveEdit = (): void => {
        if (editingId === null) return;

        const updatedItems = items.map(item =>
            item.id === editingId ? { ...item, domain: editingValue } : item
        );
        setItems(updatedItems);
        window?.electron.ipcRenderer.send("setPattern", updatedItems);
        resetEditStates();
    };

    const cancelEdit = (): void => {
        if (isAdding && newItemId !== null) {
            const updatedItems = items.filter(item => item.id !== newItemId);
            setItems(updatedItems);
            window?.electron.ipcRenderer.send("setPattern", updatedItems);
        }
        resetEditStates();
    };

    const handleEditBlur = (): void => {
        if (editingId !== null) {
            if (isAdding) {
                saveNewItem();
            } else {
                saveEdit();
            }
        }
    };

    const resetEditStates = (): void => {
        setEditingId(null);
        setEditingValue("");
        setIsAdding(false);
        setNewItemId(null);
    };

    return (
        <div className="flex pt-8 items-center justify-center flex-col gap-4 select-none scroolbar-hide">
            <div
                ref={containerRef}
                className="flex flex-col w-5/6 border-gray-500 rounded-md bg-white/5 overflow-hidden shadow-md"
                onClick={() => {
                    if (editingId !== null) {
                        resetEditStates();
                    }
                }}
            >
                <div className="flex shadow-lg border-gray-500 bg-white/5 text-sm font-medium text-gray-600 items-center justify-center flex-col gap-1">
                    <span className="text-gray-300 mt-1">{language?.PatternPage.pattern}</span>
                    <span className="text-xs mb-1 text-white/50">{language?.PatternPage.patternDescription}</span>
                </div>

                <div
                    ref={tableBodyRef}
                    className="flex-1 overflow-y-auto h-48 min-h-48 scroll-smooth"
                    style={{ maxHeight: "200px" }}
                >
                    {items.map(item => (
                        <div
                            key={item.id}
                            onClick={() => handleItemClick(item.id)}
                            onDoubleClick={() => handleDoubleClick(item)}
                            className={`flex items-center bg-white/5 shadow-xl border-gray-500 text-gray-300 rounded-md m-2 cursor-pointer h-6 ${selectedId === item.id ? "border-b border-t" : ""}`}
                        >
                            <div className="flex-1 p-2 flex items-center">
                                <span className="mr-1 text-gray-500">
                                    <DomainFavicon domain={item.domain} />
                                </span>
                                {editingId === item.id ? (
                                    <input
                                        ref={editInputRef}
                                        type="text"
                                        value={editingValue}
                                        placeholder="example.com"
                                        onChange={handleEditChange}
                                        onKeyDown={handleEditKeyDown}
                                        onBlur={handleEditBlur}
                                        className="w-max bg-white/5 shadow-xl border-blue-400 px-1 rounded focus:outline-none"
                                        autoFocus
                                    />
                                ) : (
                                    item.domain
                                )}
                            </div>
                        </div>
                    ))}
                </div>

                <div className="flex items-center shadow-lg p-2 bg-white/5">
                    <div className="flex space-x-3 shadow-xl">
                        <button
                            onClick={addItem}
                            disabled={editingId !== null}
                            className="w-6 h-6 rounded flex items-center justify-center shadow-inner shadow-gray-800 hover:bg-white/5 text-gray-300 disabled:cursor-not-allowed disabled:opacity-50"
                            title="Ekle"
                        >
                            <FaPlus size={16} />
                        </button>
                        <button
                            onClick={removeItem}
                            disabled={selectedId == null}
                            className={`w-6 h-6 rounded flex items-center shadow-inner shadow-gray-800 text-gray-300 justify-center ${selectedId !== null && !isAdding ? "hover:bg-white/5" : "text-gray-600 cursor-not-allowed"
                                }`}
                            title="Sil"
                        >
                            <FaMinus size={16} />
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default Pattern;

const hasDomain = (text: string) => {
    const domainRegex = /\b(([\w-]+\.)+[\w]{2,})\b/gi;
    return domainRegex.test(text);
};

function DomainFavicon({ domain }: { domain: string }) {
    const faviconUrl = `https://icons.duckduckgo.com/ip3/${domain.replace('https://', '')}.ico`;

    return (
        <img
            onError={(e) => {
                e.currentTarget.onerror = null;
                e.currentTarget.src = 'https://icons.duckduckgo.com/ip3/favicon.ico';
            }}
            src={faviconUrl}
            alt="favicon"
            width={16}
            height={16}
            className="rounded-full"
        />
    );
}