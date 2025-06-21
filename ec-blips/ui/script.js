const { createApp } = Vue;

// Color mapping for preview
const colorMap = {
    0: "#FFFFFF", // White
    1: "#FF0000", // Red
    2: "#00FF00", // Green
    3: "#0000FF", // Blue
    4: "#FFFF00", // Yellow
    5: "#00FFFF", // Light Blue
    6: "#FF00FF", // Purple
    7: "#FFC0CB", // Pink
    8: "#FFA500", // Orange
    39: "#FF6666", // Light Red
    46: "#000080", // Dark Blue
    52: "#006400", // Dark Green
    76: "#4B0082", // Dark Purple
    84: "#FFD700", // Gold
};

createApp({
    data() {
        return {
            showMenu: false,
            activeTab: 'list',
            blips: [],
            commonColors: [],
            commonSprites: [],
            searchQuery: '',
            
            // New blip form
            newBlip: {
                name: 'New Blip',
                sprite: 1,
                color: 0,
                scale: 0.8
            },
            customSprite: 1,
            customColor: 0,
            
            // Edit blip form
            editingBlip: null,
            editCustomSprite: 1,
            editCustomColor: 0,
            
            // Delete confirmation
            showDeleteModal: false,
            deleteBlip: null
        };
    },
    
    computed: {
        filteredBlips() {
            if (!this.searchQuery) return this.blips;
            
            const query = this.searchQuery.toLowerCase();
            return this.blips.filter(blip => 
                blip.name.toLowerCase().includes(query) || 
                blip.sprite.toString().includes(query) || 
                blip.color.toString().includes(query)
            );
        }
    },
    
    methods: {
        // Get color style for preview
        getColorStyle(colorId) {
            const color = colorMap[colorId] || `hsl(${(colorId * 20) % 360}, 70%, 50%)`;
            return {
                backgroundColor: color,
                boxShadow: `0 0 5px ${color}`
            };
        },
        
        // Close the menu
        closeMenu() {
            fetch('https://ec-blips/closeMenu', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            });
        },
        
        // Create a new blip
        createBlip() {
            if (!this.newBlip.name) {
                this.newBlip.name = 'New Blip';
            }
            
            fetch('https://ec-blips/createBlip', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.newBlip)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    this.blips = data.blips || this.blips;
                }
                this.activeTab = 'list';
                
                // Reset form
                this.newBlip = {
                    name: 'New Blip',
                    sprite: 1,
                    color: 0,
                    scale: 0.8
                };
                this.customSprite = 1;
                this.customColor = 0;
                
                // Add animation effect
                this.animateBlipList();
            })
            .catch(error => {
                console.error('Error creating blip:', error);
            });
        },
        
        // Edit a blip
        editBlip(blip) {
            this.editingBlip = { ...blip };
            this.editCustomSprite = blip.sprite;
            this.editCustomColor = blip.color;
            this.activeTab = 'edit';
        },
        
        // Save edited blip
        saveBlip() {
            if (!this.editingBlip) return;
            
            fetch('https://ec-blips/updateBlip', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.editingBlip)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update local blip data
                    const index = this.blips.findIndex(b => b.id === this.editingBlip.id);
                    if (index !== -1) {
                        this.blips[index] = { ...this.editingBlip };
                    }
                    
                    this.cancelEdit();
                    
                    // Add animation effect
                    this.animateBlipList();
                }
            })
            .catch(error => {
                console.error('Error updating blip:', error);
            });
        },
        
        // Cancel editing
        cancelEdit() {
            this.editingBlip = null;
            this.activeTab = 'list';
        },
        
        // Confirm delete modal
        confirmDelete(blip) {
            this.deleteBlip = blip;
            this.showDeleteModal = true;
        },
        
        // Delete blip confirmed
        deleteBlipConfirmed() {
            if (!this.deleteBlip) return;
            
            fetch('https://ec-blips/deleteBlip', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    id: this.deleteBlip.id
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Remove from local blips array
                    this.blips = this.blips.filter(b => b.id !== this.deleteBlip.id);
                }
                
                this.showDeleteModal = false;
                this.deleteBlip = null;
            })
            .catch(error => {
                console.error('Error deleting blip:', error);
            });
        },
        
        // Find nearest blip
        findNearestBlip() {
            fetch('https://ec-blips/getNearestBlip', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    this.editBlip(data.blip);
                } else {
                    // Show notification that no blips were found nearby
                    console.log(data.message);
                    // Add a visual notification
                    this.showNotification(data.message || 'No blips found nearby', 'error');
                }
            })
            .catch(error => {
                console.error('Error finding nearest blip:', error);
            });
        },
        
        // Add animation to blip list items
        animateBlipList() {
            setTimeout(() => {
                const blipItems = document.querySelectorAll('.blip-item');
                blipItems.forEach((item, index) => {
                    item.style.animation = 'none';
                    setTimeout(() => {
                        item.style.animation = `fadeIn 0.3s ease forwards ${index * 0.05}s`;
                    }, 10);
                });
            }, 100);
        },
        
        // Show notification (visual feedback)
        showNotification(message, type = 'info') {
            // This is a placeholder - in a real implementation, you would
            // create a notification element and show it
            console.log(`Notification (${type}): ${message}`);
        }
    },
    
    mounted() {
        // Listen for NUI messages
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            if (data.action === 'openMenu') {
                this.showMenu = true;
                this.blips = data.blips || [];
                this.commonColors = data.commonColors || [];
                this.commonSprites = data.commonSprites || [];
                this.activeTab = 'list';
                
                // Add animation effect
                this.$nextTick(() => {
                    this.animateBlipList();
                });
            } else if (data.action === 'closeMenu') {
                this.showMenu = false;
            }
        });
        
        // Close on escape key
        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape' && this.showMenu) {
                this.closeMenu();
            }
        });
    }
}).mount('#app');
