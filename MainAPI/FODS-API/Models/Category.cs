using System;
using System.Collections.Generic;

namespace FODS_API.Models
{
    public partial class Category
    {
        public Category()
        {
            Products = new HashSet<Product>();
        }

        public int CategoryId { get; set; }
        public string Name { get; set; } = null!;
        public string ImgUrl { get; set; } = null!;

        public virtual ICollection<Product> Products { get; set; }
    }
}
