using System;
using System.Collections.Generic;

namespace FODS_API.Models
{
    public partial class Order
    {
        public Order()
        {
            OrderItems = new HashSet<OrderItem>();
        }

        public int OrderId { get; set; }
        public int UserId { get; set; }
        public int EmployeeId { get; set; }
        public string OrderStatus { get; set; } = null!;
        public bool IsDelivered { get; set; }
        public bool IsProcessed { get; set; }
        public bool IsReceived { get; set; }
        public TimeSpan Time { get; set; }
        public double TotalPrice { get; set; }
        public double Longitude { get; set; }
        public double Latitude { get; set; }

        public virtual Employee Employee { get; set; } = null!;
        public virtual User User { get; set; } = null!;
        public virtual ICollection<OrderItem> OrderItems { get; set; }
    }
}
