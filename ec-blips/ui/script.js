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
            spriteCategories: [],
            searchQuery: '',
            
            // New blip form
            newBlip: {
                name: 'New Blip',
                sprite: 1,
                color: 0,
                scale: 0.8,
                shortRange: true  // Default to true (only visible when nearby)
            },
            customSprite: 1,
            customColor: 0,
            
            // Sprite selection
            selectedCategory: 0,
            spriteSearch: '',
            spritePage: 1,
            spritesPerPage: 24,
            
            // Edit blip form
            editingBlip: null,
            editCustomSprite: 1,
            editCustomColor: 0,
            editSelectedCategory: 0,
            editSpriteSearch: '',
            editSpritePage: 1,
            
            // Delete confirmation
            showDeleteModal: false,
            deleteBlip: null
        };
    },
    
    computed: {
        // Filtered blips for the list view
        filteredBlips() {
            if (!this.searchQuery) return this.blips;
            
            const query = this.searchQuery.toLowerCase();
            return this.blips.filter(blip => 
                blip.name.toLowerCase().includes(query) || 
                blip.sprite.toString().includes(query) || 
                blip.color.toString().includes(query)
            );
        },
        
        // Get all sprites from the selected category
        categorySprites() {
            if (this.selectedCategory === -1) {
                // All sprites
                let allSprites = [];
                this.spriteCategories.forEach(category => {
                    allSprites = allSprites.concat(category.sprites);
                });
                return allSprites;
            } else if (this.spriteCategories[this.selectedCategory]) {
                // Selected category
                return this.spriteCategories[this.selectedCategory].sprites || [];
            }
            return this.commonSprites || [];
        },
        
        // Filtered sprites based on search
        filteredSprites() {
            if (!this.spriteSearch) return this.categorySprites;
            
            const query = this.spriteSearch.toLowerCase();
            return this.categorySprites.filter(sprite => 
                sprite.name.toLowerCase().includes(query) || 
                sprite.id.toString().includes(query)
            );
        },
        
        // Paginated sprites
        paginatedFilteredSprites() {
            const start = (this.spritePage - 1) * this.spritesPerPage;
            return this.filteredSprites.slice(start, start + this.spritesPerPage);
        },
        
        // Total pages
        totalSpritePages() {
            return Math.ceil(this.filteredSprites.length / this.spritesPerPage);
        },
        
        // Edit mode - Get all sprites from the selected category
        editCategorySprites() {
            if (this.editSelectedCategory === -1) {
                // All sprites
                let allSprites = [];
                this.spriteCategories.forEach(category => {
                    allSprites = allSprites.concat(category.sprites);
                });
                return allSprites;
            } else if (this.spriteCategories[this.editSelectedCategory]) {
                // Selected category
                return this.spriteCategories[this.editSelectedCategory].sprites || [];
            }
            return this.commonSprites || [];
        },
        
        // Edit mode - Filtered sprites based on search
        filteredEditSprites() {
            if (!this.editSpriteSearch) return this.editCategorySprites;
            
            const query = this.editSpriteSearch.toLowerCase();
            return this.editCategorySprites.filter(sprite => 
                sprite.name.toLowerCase().includes(query) || 
                sprite.id.toString().includes(query)
            );
        },
        
        // Edit mode - Paginated sprites
        paginatedFilteredEditSprites() {
            const start = (this.editSpritePage - 1) * this.spritesPerPage;
            return this.filteredEditSprites.slice(start, start + this.spritesPerPage);
        },
        
        // Edit mode - Total pages
        totalEditSpritePages() {
            return Math.ceil(this.filteredEditSprites.length / this.spritesPerPage);
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
        
        // Get sprite style for preview
        getSpriteStyle(spriteId) {
            return {
                backgroundColor: `hsl(${(spriteId * 20) % 360}, 70%, 50%)`,
                color: '#fff',
                fontWeight: 'bold'
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
            this.editingBlip = { 
                ...blip,
                shortRange: blip.shortRange === 1 || blip.shortRange === true
            };
            this.editCustomSprite = blip.sprite;
            this.editCustomColor = blip.color;
            this.editSelectedCategory = 0; // Reset to first category
            this.editSpriteSearch = '';
            this.editSpritePage = 1;
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
        // In the mounted function where we process the data from the server
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            if (data.action === 'openMenu') {
                this.showMenu = true;
                
                // Make sure shortRange is properly converted from 0/1 to boolean
                this.blips = (data.blips || []).map(blip => ({
                    ...blip,
                    shortRange: blip.shortRange === 1 || blip.shortRange === true
                }));
                
                this.commonColors = data.commonColors || [];
                this.commonSprites = data.commonSprites || [];
                this.spriteCategories = data.spriteCategories || [];
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
