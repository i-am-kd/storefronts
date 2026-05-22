export interface Store {
    store_id: string;
    name: string;
    email: string;
    location: [number, number]
    timezone: string;
    status: 'active' | 'suspended'|'archived'
}

export interface Product{
    product_id: string;
    store_id: string
    sku: string;
    name: string;
    price: number;
    stock_count: number;
    status: 'active' |'discontinued' |'out_of_stock'
}

export interface ApiResponse<T>{
    data: T;
    message?: string;
}